package com.s3s.solutions.eone.service.wmd.traylocation;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.mybatis.DefaultMapper;
import com.s3s.solutions.eone.service.wmd.traylocation.dto.TrayLocationDTO;

@Mapper
public interface TrayLocationMapper extends DefaultMapper<TrayLocationDTO>{

	public List<TrayLocationVO> selectRackInTrayList(@Param("param") TrayLocationVO vo);
	public List<TrayLocationVO> selectRackEmptyCellList();
	public List<TrayLocationVO> selectRackEmptyCellListByLineNo(@Param("lineNo") String lineNo);
	public List<TrayLocationVO> selectGenerateRackEmptyCellListByLineNo(@Param("lineNo") String lineNo, @Param("trayCount") int trayCount);
	public int selectTrayLocationListTotalRows(@Param("param") TrayLocationVO vo);
	public List<TrayLocationVO> selectTrayLocationPagingList(@Param("param") TrayLocationVO vo, @Param("paging") PagingDTO paging);
	public List<TrayLocationVO> selectRackCellStoragedTrayList();
	public List<TrayLocationVO> selectTrayLocationListByOrderId(@Param("param") TrayLocationVO vo);
	public TrayLocationVO selectTrayLocationByTrayIdLocType(@Param("param") TrayLocationVO vo);
	
	public List<TrayLocationVO> selectRackInTrayCountPerLineNo();

}