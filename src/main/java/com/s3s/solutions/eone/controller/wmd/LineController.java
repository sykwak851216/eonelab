package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.service.wmd.line.LineService;
import com.s3s.solutions.eone.service.wmd.line.LineVO;
import com.s3s.solutions.eone.service.wmd.line.dto.LineDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("라인")
@RequestMapping(value = "/solutions/eone/wmd/line")
public class LineController {

	private final LineService lineService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<LineDTO> getPagingList(LineDTO vo, PagingDTO page) throws Exception {
		return lineService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<LineDTO> getList(LineDTO vo) throws Exception {
		return lineService.getList(vo);
	}

	@RequestMapping(value = "/getDetail", method = { RequestMethod.GET, RequestMethod.POST })
	public LineVO getDetail(LineVO vo) throws Exception {
		return lineService.getDetail(vo);
	}
}