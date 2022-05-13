package com.globalin.ex02;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.globalin.domain.BoardVO;
import com.globalin.domain.Criteria;
import com.globalin.mapper.BoardMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardMapperTest {
   @Autowired
   private BoardMapper bm;

//   @Test
//   public void testGetList() {
//      List<BoardVO> list = bm.getList();
////      for (BoardVO b : list) {
////         System.out.println(b);
////      }
//   }
//
//   @Test
//   public void insertTest() {
////      BoardVO board = new BoardVO();
////      board.setTitle("새 작성글");
////      board.setContent("새 내용글");
////      board.setWriter("newbie");
////      bm.insert(board);
//
//   }
//
//   @Test
//   public void testInsertSelectKeyTest() {
////      BoardVO board = new BoardVO();
////      board.setTitle("새로 작성하는 select key");
////      board.setContent("새 내용글 select key");
////      board.setWriter("newbie");
////      bm.insertSelectKey(board);
//   }
//
//   @Test
//   public void readTest() {
////      BoardVO board = new BoardVO();
////      board.setBno(1);
////      System.out.println(bm.read(1));
//   }
//
//   @Test
//   public void updateTest() {
////      BoardVO board = bm.read(1);
////      board.setTitle("수정글");
////      board.setContent("수정 내용글");
////      board.setWriter("Oldbie");
////      bm.update(board);
//   }

   @Test
   public void testPaging() {
      Criteria cri = new Criteria();
      List<BoardVO> list = bm.getListWithPaging(cri);

      for (BoardVO board : list) {
         System.out.println(board);
      }
      
      BoardVO b = bm.read(99999999);
      System.out.println(b);
   }

}