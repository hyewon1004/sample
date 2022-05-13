package com.globalin.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.globalin.domain.CustomUser;
import com.globalin.domain.MemberVO;
import com.globalin.mapper.MemberMapper;

//이클래스는 스프링 시쿠리티의 유저정보를(인증,권한) 데이터베이스에서 가져와 주는 역활을 하게 된다
public class CustomUserDetailService implements UserDetailsService {
	private Logger log = LoggerFactory.getLogger(CustomUserDetailService.class);
	
	@Autowired
	private MemberMapper mapper;
	
	/*UserDetailsService는 loadUserByUserName()이라는 하나의 추상메소드
	 * 리턴타입이 org.springframework.core.userdetails.UserDetails
	 * 스프링에서 취급하는 사용자 정보객체는 오직userDetails타입
	 * 우리가 만든 사용자 정보객체는 memberVO타입이다
	 * 그래서 우리가 만든 사용자 정보객채를 스프링 시큐리티가 사용할수있ㄷ도록
	 * memberVO타입을 userDetails 타입으로 변환하는 작업이 필요
	 * 1)memberVO클래스를 userdetails 인터페이스를 구현하도록 하는 방법
	 * 2)제3의 클래스를 이용해서 MemberVO클래스를 수정하지 않고 하는 방법
	 * 
	 */

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		
		log.warn("Load User By UserName :" + username);
		//username으로 memberVO객체 가져오기
		MemberVO vo=mapper.read(username);
		log.warn("queried by mapper : " + vo);
		
		//매퍼가 vo를 가져왔으면 memberVO를 스프링 시큐리티가 사용하는 타입으로 변경
		//vo를  가져오지 못했으면 그대로 null리턴
		return vo == null ? null : new CustomUser(vo);
		
	}

}
