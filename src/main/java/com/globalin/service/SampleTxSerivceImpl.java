package com.globalin.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.globalin.mapper.Sample1Mapper;
import com.globalin.mapper.Sample2Mapper;

@Service
//@Transactional
public class SampleTxSerivceImpl implements SampleTxService {
	
	//로그
	private Logger log = LoggerFactory.getLogger(SampleTxSerivceImpl.class);

	@Autowired
	private Sample1Mapper mapper1;
	
	@Autowired
	private Sample2Mapper mapper2;
	
	//이 메소드에 트랜잭션 처리를 하겠다.
	//이 메소드 실행 도중에 예외가 발생하거나 기능을 실행하는데 실패하면 
	//실행 결과를 모두 롤백해서 없던 걸로 간주한다.
	//반대로 다 성공 시 그대로 성공하도록 한다.
	
	@Transactional
	@Override
	public void addData(String value) {
		// TODO Auto-generated method stub
		
		log.info("mapper1.....");
		mapper1.insertCol1(value);
		
		log.info("mapper2.....");
		mapper2.insertCol2(value);
		
		log.info("end.........");
		
		//우리가 원하는 결과는 하나가 안되면 다 안되거나
		//다 되거나
	}

}
