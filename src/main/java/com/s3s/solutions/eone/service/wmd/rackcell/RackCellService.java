package com.s3s.solutions.eone.service.wmd.rackcell;

import java.util.List;

import org.springframework.stereotype.Service;

import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.service.wmd.rackcell.dto.RackCellDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class RackCellService extends DefaultService<RackCellDTO, RackCellMapper>{

	public List<RackCellVO> getRackCellListByGantry(RackCellVO vo){
		return getMapper().selectRackCellListByGantry(vo);
	}
	
	/*
	 * 랙과 x, y로 랙셀 조회
	 */
	public RackCellVO getRackCellByRackAndXY(String rackId, int rackCellXAxis, int rackCellYAxis) throws Exception{
		return ListTools.getFirst(getList(new RackCellVO() {{
			setRackId(rackId);
			setRackCellXAxis(rackCellXAxis);
			setRackCellYAxis(rackCellYAxis);
		}}));
	}

}