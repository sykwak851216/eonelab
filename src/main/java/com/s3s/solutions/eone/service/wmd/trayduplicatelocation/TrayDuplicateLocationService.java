package com.s3s.solutions.eone.service.wmd.trayduplicatelocation;

import java.util.List;

import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.dto.TrayDuplicateLocationDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class TrayDuplicateLocationService extends DefaultService<TrayDuplicateLocationDTO, TrayDuplicateLocationMapper>{

	/**
	 * TARY 중복 체크
	 * @return
	 */
	public List<TrayDuplicateLocationVO> getTaryDuplicateResult(String trayId) {
		return getMapper().selectTrayduplicationResult(trayId);
	}
	
}