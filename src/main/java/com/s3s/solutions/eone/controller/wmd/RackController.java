package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.biz.RackBizService;
import com.s3s.solutions.eone.service.wmd.rack.RackService;
import com.s3s.solutions.eone.service.wmd.rack.RackVO;
import com.s3s.solutions.eone.service.wmd.rack.dto.RackDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("랙")
@RequestMapping(value = "/solutions/eone/wmd/rack")
public class RackController {

	private final RackService rackService;
	private final RackBizService rackBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<RackDTO> getPagingList(RackDTO vo, PagingDTO page) throws Exception {
		return rackService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<RackDTO> getList(RackDTO vo) throws Exception {
		return rackService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(RackDTO vo) throws Exception {
		rackService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(RackDTO vo) throws Exception {
		rackService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(RackDTO vo) throws Exception {
		rackService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<RackDTO> list) throws Exception {
		rackService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<RackDTO> list) throws Exception {
		rackService.deleteList(list);
	}

}