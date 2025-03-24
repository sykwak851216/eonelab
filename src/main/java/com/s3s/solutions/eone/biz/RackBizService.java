package com.s3s.solutions.eone.biz;

import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.SfpConst;
import com.s3s.solutions.eone.service.wmd.rack.RackService;
import com.s3s.solutions.eone.service.wmd.rack.RackVO;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellService;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class RackBizService {

	private final RackService rackService;
	private final RackCellService rackCellService;

	public List<RackVO> getCellListByRackId(RackCellVO vo) throws Exception{
		List<RackVO> rackList = rackService.getList(new RackVO() {{ setMcId(vo.getMcId()); }});
		List<RackCellVO> rackCellList = rackCellService.getRackCellListByGantry(vo);
		for (RackVO rack : rackList) {
			rack.setRackCellList(rackCellList.stream().filter(rc -> StringUtils.equals(rack.getRackId(), rc.getRackId())).collect(Collectors.toList()));
		}
		return rackList;
	}
	
	
	public List<RackVO> getCellListByLineNo(RackCellVO vo) throws Exception{
		List<RackVO> rackList = rackService.getList(new RackVO() {{
			setLineNo(vo.getLineNo());
			setDelYn(SfpConst.YN_N);
		}});
		
		vo.setDelYn(SfpConst.YN_N);
		
		List<RackCellVO> rackCellList = rackCellService.getRackCellListByGantry(vo);
		for (RackVO rack : rackList) {
			rack.setRackCellList(rackCellList.stream().filter(rc -> StringUtils.equals(rack.getRackId(), rc.getRackId())).collect(Collectors.toList()));
			rack.setExistCount(rack.getRackCellList().stream().filter(rc -> StringUtils.isNotEmpty(rc.getTrayId())).collect(Collectors.toList()).size());
		}
		return rackList;
	}

}