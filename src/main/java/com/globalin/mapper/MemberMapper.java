package com.globalin.mapper;

import com.globalin.domain.MemberVO;
/*
 * MemberVO객체는 내부적으로 여러개의 AuthVO 객체를 가질수있게 설계
 * 하나의데이터가 여러개의 하위 데이터를 포함 하고 있다 1:n관계
 * 이런 관계를 Mybatis에서 처리해야 할떄 resultMap을 사용
 */

public interface MemberMapper {
	
	public MemberVO read(String userid);
	

}
