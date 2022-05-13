package com.globalin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.globalin.domain.BoardVO;
import com.globalin.domain.Criteria;

public interface BoardMapper {

	//@Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
	
	//페이지 처리된 만큼 가져오기
	public List<BoardVO> getListWithPaging(Criteria cri);
	public void insert(BoardVO board);
	public void insertSelectKey(BoardVO board);
	
	//하나 가져오기
	public BoardVO read(int bno);
	
	//하나 지우기
	public int delete(int bno);
	
	//수정하기
	public int update(BoardVO board);
	
	//총 저장되어 있는 board 개수 구하기
	public int getTotalCount(Criteria cri);
	
	//게시물의 댓글수 업데이트 하기
	public void updateReplyCnt(@Param("bno") int bno,
			@Param("amount") int amount
			);
}

