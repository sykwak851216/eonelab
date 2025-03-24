package com.s3s.solutions.eone.manager;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.s3s.sfp.settings.accessor.ServerPropertiesAccessor;
import com.s3s.solutions.eone.biz.InterfaceBizService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 이원 프로시저를 실행해서 지시목록을 받아와서 처리함
 * @author choi
 *
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class InterfaceManager {

	private final InterfaceBizService interfaceBizService;


	public boolean isRunable() {
		if ("y".equalsIgnoreCase(ServerPropertiesAccessor.getDmwYn())) {
			return true;
		}
		return false;
	}

	@Scheduled(fixedDelay=10000)
	public void taskInteface() {
		if (!isRunable()) {
			return;
		}
		try {
			executeInterface();
		} catch (Exception e) {
			log.error("이원 인터페이스 실패", e);
		}
	}

	public void executeInterface() throws Exception{
		interfaceBizService.procYudoList();
	}

}
