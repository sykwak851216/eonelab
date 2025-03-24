package com.s3s.solutions.eone.service.wmd.traylocation;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.sfp.service.mybatis.DefaultService;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.service.wmd.traylocation.dto.TrayLocationDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class TrayLocationService extends DefaultService<TrayLocationDTO, TrayLocationMapper>{

	/**
	 * RACK에 있는 TRAY 목록
	 * @return
	 */
	public List<TrayLocationVO> getRackInTrayList(TrayLocationVO vo){
		return getMapper().selectRackInTrayList(vo);
	}

	/**
	 * RACK에 비어 있는 공간 목록
	 * @return
	 */
	public List<TrayLocationVO> getRackEmptyCellList(){
		return getMapper().selectRackEmptyCellList();
	}
	
	/**
	 * Line별 RACK에 비어 있는 공간 목록
	 * @return
	 */
	public List<TrayLocationVO> getRackEmptyCellListByLineNo(String lineNo){
		return getMapper().selectRackEmptyCellListByLineNo(lineNo);
	}
	
	/**
	 * Line별 RACK에 비어 있는 공간 목록
	 * @return
	 */
	public List<TrayLocationVO> getGenerateRackEmptyCellListByLineNo(String lineNo, int trayCount){
		return getMapper().selectGenerateRackEmptyCellListByLineNo(lineNo, trayCount);
	}

	/**
	 * RACK에 있는 빈셀 목록을 GANTRY로 GROUP BY
	 * @return
	 */
	public List<TrayLocationSummaryVO> getRackEmptyCellListGroupByMcId(){
		return groupByGantryFromTrayLocation(this.getRackEmptyCellList());
	}
	
	/**
	 * RACK에 있는 빈셀 목록을 LineNo로 GROUP BY
	 * @return
	 */
	public List<TrayLocationSummaryVO> getRackEmptyCellListGroupByLineNo(String lineNo){
		return groupByLineFromTrayLocation(this.getRackEmptyCellListByLineNo(lineNo));
	}

	/**
	 * RACK에 있는 TRAY 목록을 GANTRY로 GROUP BY
	 * @return
	 */
	public List<TrayLocationSummaryVO> getRackInTrayListGroupByMcId(){
		return groupByGantryFromTrayLocation(this.getRackInTrayList(null));
	}
	
	/**
	 * 
	 * @param rackInTrayList : 각 렉별로 비어있는 셀 목
	 * @return
	 */
	private List<TrayLocationSummaryVO> groupByGantryFromTrayLocation(List<TrayLocationVO> rackInTrayList) {
		List<TrayLocationSummaryVO> trayLocationSummaryList = new ArrayList<>();
		
		for (TrayLocationVO trayLocationVO : rackInTrayList) {
			TrayLocationSummaryVO trayLocationSummaryVO = getTrayLocationSummaryVO(trayLocationSummaryList, trayLocationVO.getMcId());
			if(trayLocationSummaryVO == null) {
				trayLocationSummaryVO = new TrayLocationSummaryVO();
				trayLocationSummaryVO.setMcId(trayLocationVO.getMcId());
				trayLocationSummaryList.add(trayLocationSummaryVO);
			}
			trayLocationSummaryVO.getTrayLocationList().add(trayLocationVO);
		}
		return trayLocationSummaryList
				.stream()
				.sorted(Comparator.comparing(TrayLocationSummaryVO::getTrayLocationListSize).reversed())
				.collect(Collectors.toList());
	}

	/**
	 * 해당 라인에 있는 렉 셀리트를 반환한다.
	 * @param rackInTrayList : 각 렉별로 비어있는 셀 목
	 * @return 해당 라인에 비어 있는 렉 셀리트를 반환한다
	 */
	private List<TrayLocationSummaryVO> groupByLineFromTrayLocation(List<TrayLocationVO> rackInTrayList) {
		List<TrayLocationSummaryVO> trayLocationSummaryList = new ArrayList<>();
		
		if(!ListTools.isNullOrEmpty(rackInTrayList)) {
			TrayLocationSummaryVO trayLocationSummaryVO = new TrayLocationSummaryVO();
			trayLocationSummaryVO.setMcId(rackInTrayList.get(0).getMcId());
			trayLocationSummaryVO.setLineNo(rackInTrayList.get(0).getLineNo());
			trayLocationSummaryVO.setTrayLocationList(rackInTrayList);
			trayLocationSummaryList.add(trayLocationSummaryVO);
		}
		
		
		return trayLocationSummaryList;
	}

	/**
	 * @param trayLocationSummaryList
	 * @param mcId
	 * @return
	 */
	public TrayLocationSummaryVO getTrayLocationSummaryVO(List<TrayLocationSummaryVO> trayLocationSummaryList, String mcId) {
		for (TrayLocationSummaryVO trayLocationSummaryVO : trayLocationSummaryList) {
			if(StringUtils.equals(trayLocationSummaryVO.getMcId(), mcId)) {
				return trayLocationSummaryVO;
			}
		}
		return null;
	}

	public List<TrayLocationVO> getTrayLocationList(TrayLocationVO vo) {
		return getMapper().selectTrayLocationPagingList(vo, null);
	}

	public PagingListDTO<TrayLocationVO> getTrayLocationPagingList(TrayLocationVO vo, PagingDTO paging) {
		paging.setTotalElements(getMapper().selectTrayLocationListTotalRows(vo));
		if(paging.getTotalElements() > 0) {
			paging.setTotalPages((int) ((paging.getTotalElements()-1) / paging.getSize() + 1));
		}

		PagingListDTO<TrayLocationVO> pagingList = new PagingListDTO<TrayLocationVO>();
		pagingList.setList(getMapper().selectTrayLocationPagingList(vo, paging));
		pagingList.setPaging(paging);
		return pagingList;
	}

	public List<TrayLocationVO> getRackCellStoragedTrayList(){
		return getMapper().selectRackCellStoragedTrayList();
	}
	
	
	public List<TrayLocationVO> getTrayLocationListByOrderId(TrayLocationVO vo){
		return getMapper().selectTrayLocationListByOrderId(vo);
	}
	
	public TrayLocationVO getTrayLocationByTrayIdLocType(TrayLocationVO vo){
		return getMapper().selectTrayLocationByTrayIdLocType(vo);
	}
	
	public List<TrayLocationVO> getRackInTrayCountPerLineNo(){
		return getMapper().selectRackInTrayCountPerLineNo();
	}
}