package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.solutions.eone.manager.BufferManager;
import com.s3s.solutions.eone.manager.BufferSensorVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("버퍼")
@RequestMapping(value = "/solutions/eone/wmd/buffer")
public class BufferController {

	private final BufferManager bufferManager;

	/*
	@RequestMapping(value = { "/getBufferSensors" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<BufferSensorVO> getBufferSensors() throws Exception {
		return bufferManager.getBufferSensors();
	}
	*/
	
	/**
	 * 
	 * @param lineNo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "/getBufferSensorsByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<BufferSensorVO> getBufferSensorsByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return bufferManager.getBufferSensorsByLineNo(lineNo);
	}

}