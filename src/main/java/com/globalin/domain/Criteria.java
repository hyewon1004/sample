package com.globalin.domain;

//검색 정보까지 담도록 수정

public class Criteria {

	private int pageNum;
	private int amount;
	
	//검색 타입 : 제목, 작성자, 내용...(제목 + 내용)
	private String type;
	//검색할 키워드
	private String keyword;
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	@Override
	public String toString() {
		return "Criteria [pageNum=" + pageNum + ", amount=" + amount + ", type=" + type + ", keyword=" + keyword + "]";
	}
	
	
	public Criteria() {
		this.pageNum = 1;
		this.amount = 10;
	}
//	public int getPageNum() {
//		return pageNum;
//	}
//	public void setPageNum(int pageNum) {
//		//첫 페이지 번호는 1, 기본적으로 한 페이지에 10개씩
//		this.pageNum = pageNum;
//	}
//	public int getAmount() {
//		return amount;
//	}
//	public void setAmount(int amount) {
//		this.amount = amount;
//	}
//	@Override
//	public String toString() {
//		return "Criteria [pageNum=" + pageNum + ", amount=" + amount + "]";
//	}
//	
	   // type 을 쪼개서 문자열 배열로 만들어서 리턴 해주는 메소드
	   // type = "TWC"
	   // String[] typeArr = {"T", "W", "C"}
	   public String[] getTypeArr() {
	      String[] result = {};
	      if (type == null) {
	         // type이 널이면 검색 조건이 없는 것
	         // 빈 배열 return
	      } else {
	         result = type.split("");
	      }
	      return result;
	      // return type == null ? new String[] {} : type.split("");
	   }
}
