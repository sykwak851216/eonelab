package com.s3s.solutions.eone.service.wmd.order;

import java.util.ArrayList;
import java.util.List;

import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderSaveVO{

	private String mcId;
	private String lineNo;

	//SORT 가중치
	private int sortWeightValue;

	private List<OrderTrayVO> orderTrayList = new ArrayList<>();

	public int getOrderTrayListSize() {
		return orderTrayList.size();
	}

	public void plusSortWeightValue(int value) {
		sortWeightValue += value;
	}

}