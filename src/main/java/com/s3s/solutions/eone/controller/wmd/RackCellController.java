package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.rackcell.RackCellService;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellVO;
import com.s3s.solutions.eone.service.wmd.rackcell.dto.RackCellDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("랙셀")
@RequestMapping(value = "/solutions/eone/wmd/rackcell")
public class RackCellController {

	private final RackCellService rackCellService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<RackCellDTO> getPagingList(RackCellDTO vo, PagingDTO page) throws Exception {
		return rackCellService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<RackCellDTO> getList(RackCellDTO vo) throws Exception {
		return rackCellService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(RackCellDTO vo) throws Exception {
		rackCellService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(RackCellDTO vo) throws Exception {
		rackCellService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(RackCellDTO vo) throws Exception {
		rackCellService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<RackCellDTO> list) throws Exception {
		rackCellService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<RackCellDTO> list) throws Exception {
		rackCellService.deleteList(list);
	}

}