package com.s3s.solutions.eone.service.wmd.ordertray;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.ordertray.dto.OrderTrayDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class OrderTrayService extends DefaultService<OrderTrayDTO, OrderTrayMapper>{

	/**
	 * 라인의 입고 처리
	 * @param trayId
	 * @param orderTrayList
	 * @throws Exception
	 */
	@Transactional(rollbackFor = { Exception.class })
	public int duplicateTrayId(String trayId) throws Exception {
		return getMapper().selectTrayduplicationResult(trayId);
	}
}