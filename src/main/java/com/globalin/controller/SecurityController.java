package com.globalin.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/security/*")
public class SecurityController {
	
	private Logger log = LoggerFactory.getLogger(SecurityController.class);
			
		
			//security/all:로그인하지않은 사용자들도접근가능한 uri
			@GetMapping("/all")
			public void doAll() {
		log.info("everyone can access this page");
	}
			//security/member:로그인한 사용자들만 접근 가능한 uri
             @GetMapping("/member")
             public void doMember() {
            	 log.info("member can access this page");
             }
			//security/
             @GetMapping("/admin")
             public void daAdmin() {
            	 log.info("admin can access this page");
            	 
             }

}
