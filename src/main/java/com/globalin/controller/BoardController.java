package com.globalin.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.globalin.domain.BoardVO;
import com.globalin.domain.Criteria;
import com.globalin.domain.Page;
import com.globalin.service.BoardService;

@Controller // 스프링에서 componentScan으로 인식할 수 있도록
@RequestMapping("/board/*") // 이 컨트롤러가 어떤 경로로 요청을 처리하는지 설정해준다는 어노테이션
public class BoardController {

	// 컨트롤러에서 우리가 구현해놓은 비즈니스 로직을 사용하기 위해 필요한 객체
	// service가 필요==>스프링한테 주입해달라고 요청
	@Autowired
	private BoardService service;

	// 로그
	private static Logger log = LoggerFactory.getLogger(BoardController.class);

	// 전체 리스트 조회 기능
	// 스프링에서 사용하는 데이터 전달자인 Model을 사용해서 데이터를 넘겨주도록 해본다.
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list : " + cri);
		// request에 Attribute를 담았던 것처럼 할 수 있다.
		int total = service.getTotal(cri);
		model.addAttribute("list", service.getList(cri));
		log.info("total : " + total);
		log.info(new Page(cri, total).toString());
		model.addAttribute("pageMaker", new Page(cri, total));
	}

	@GetMapping("/register")
	//로그인 한 사용자만 게시글 등록 페이지로 갈수 있도록 한다
	@PreAuthorize("isAuthenticated()")
	public void register() {
		// 메소드 리턴 타입이 void ==> url 이름이 jsp 파일 이름
		/// board/register 요청을 보내면 register.jsp 파일을 찾아서 사용자한테 보여준다.
	}

	// 등록기능
	// form에서 사용자가 게시물 정보를 입력하고 작성 요청을 보냄
	// 보내고 나서 화면을 전환 ==> 리스트 화면으로 돌아가도록
	// 리스트 화면으로 돌아가면서 방금 작성한 게시물의 번호를 담아주자.
	// 리다이렉트로 보내주기
	@PostMapping("/register")
	//인증이 된 사용자만 게시글작성이 가능하도록 설정을 추가
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : " + board);

		service.register(board);
		// 리다이렉트 하면 요청 정보가 사라진다.
		// 1회용 정보를 담아주는 flashAttribute를 사용
		rttr.addFlashAttribute("result", board.getBno());
		// response.sendRedirect();
		// response객체가 없어서 직접 사용하지 못하니까
		// return 할 string에 redirect 한다고 표시
		return "redirect:/board/list";
	}

	// 하나가져오기
	// 파라미터로 가져올 게시물의 번호가 필요
	// 번호를 통해서 db에서 조회한 게시물의 정보를 전달
	// 데이터 전달자 Model을 사용해서 전달
	@GetMapping("/get")
	public void get(@RequestParam("bno") int bno, Criteria cri, Model model) {
		log.info("get : " + bno);
		log.info("cri : " + cri);
		// 게시물의 정보를 전달
		// 서비스에서 board 정보 가져온 다음에
		// model에 넣어주면 된다.
		BoardVO board = service.get(bno);
		model.addAttribute("cri", cri);
		model.addAttribute("board", board);

	}

	@GetMapping("/modify")
	public void modify(@RequestParam("bno") int bno, Criteria cri, Model model) {
		log.info("get : " + bno);
		log.info("cri : " + cri);
		// 게시물의 정보를 전달
		// 서비스에서 board 정보 가져온 다음에
		// model에 넣어주면 된다.
		BoardVO board = service.get(bno);
		model.addAttribute("cri", cri);
		model.addAttribute("board", board);

	}

	// 수정 작업 이후에 리스트 페이지로 돌아가게 하고 싶다.
	// redirect
	   @PostMapping("/modify")
	   @PreAuthorize("principal.username == #board.writer")
	   public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
	      // httpServlet 클래스를 상속받아서 만든다.
	      // doGet(HttpServletRequest req, ....) 해서
	      // req.geParameter("title"), 이렇게 직접 해야하는데 이걸 스프링이 대신 해줌
	      log.info("modify:" + board);
	      if (service.modify(board) == true) {
	         rttr.addFlashAttribute("result", "success");
	      }
	      rttr.addAttribute("pageNum", cri.getPageNum());
	      rttr.addAttribute("amount", cri.getAmount());
	      return "redirect:/board/list";
	   }

	// 삭제 후 리스트 페이지로 이동
	// 파라미터가 필요한가?
	// post
	   //스프링시큐리티의 어노테이션을 이용해서 로그인한 사용자== 게시물 작성자일때만 삭제
	   //#파라미터를 사용할수 있음
	   //#(input)태그의 name속성 대신 메소드의 파라미터로 받아 와야함
	   @PreAuthorize("principal.username == #writer")
	   @PostMapping("/remove")
	   public String remove(@RequestParam("bno") int bno, Criteria cri, RedirectAttributes rttr , String writer) {
	      log.info("remove:" + bno);
	      if (service.remove(bno)) {
	         rttr.addFlashAttribute("result", "success");
	      }
	      rttr.addAttribute("pageNum", cri.getPageNum());
	      rttr.addAttribute("amount", cri.getAmount());
	      return "redirect:/board/list";
	   }
}
