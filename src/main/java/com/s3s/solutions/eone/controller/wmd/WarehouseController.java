package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.warehouse.WarehouseService;
import com.s3s.solutions.eone.service.wmd.warehouse.dto.WarehouseDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("창고")
@RequestMapping(value = "/solutions/eone/wmd/warehouse")
public class WarehouseController {

	private final WarehouseService warehouseService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<WarehouseDTO> getPagingList(WarehouseDTO vo, PagingDTO page) throws Exception {
		return warehouseService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<WarehouseDTO> getList(WarehouseDTO vo) throws Exception {
		return warehouseService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(WarehouseDTO vo) throws Exception {
		warehouseService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(WarehouseDTO vo) throws Exception {
		warehouseService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(WarehouseDTO vo) throws Exception {
		warehouseService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<WarehouseDTO> list) throws Exception {
		warehouseService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<WarehouseDTO> list) throws Exception {
		warehouseService.deleteList(list);
	}

}