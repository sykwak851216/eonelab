package com.s3s.solutions.eone.service.wmd.rack;

import java.util.ArrayList;
import java.util.List;

import com.s3s.solutions.eone.service.wmd.rack.dto.RackDTO;
import com.s3s.solutions.eone.service.wmd.rackcell.RackCellVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RackVO extends RackDTO {

	private List<RackCellVO> rackCellList = new ArrayList<RackCellVO>();
	private Integer existCount;

}