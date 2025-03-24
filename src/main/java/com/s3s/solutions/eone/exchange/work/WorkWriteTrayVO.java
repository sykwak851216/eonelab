package com.s3s.solutions.eone.exchange.work;

import org.apache.commons.codec.binary.StringUtils;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WorkWriteTrayVO {
	private String gb;     //READ(리스트 확인), OUT(호출), DEL(폐기), IN(보관)
	private String entYmd; //(신청일 YYYYMMDD)
	private String targetNo; //(rack 번호)
	private String result; //(완료구분 Y/N) 
	private String remark; //(오류 상세 내역)
	private String lineNo;
	private String rackNo; //위치B(좌,우 - 1/2),
	private String floor;
	private String colume;
	private String rtnResult;
	private String type;
	@Getter(AccessLevel.NONE)
	private String div;
	private String seq;
	
	public String getDiv() {
		String result = "";
		if (StringUtils.equals("IN", this.getGb())) {
			//보관작업(IN) :GB||구분자||ENT_YMD||구분자||TARGETNO||구분자||위치A|| 구분자||위치B||구분자||위치C||구분자||위치D
			//‘IN’||CHAR(19)||’20200518’||CHAR(19)||’0002’||CHAR(19)||’1’||CHAR(19)||’1’||CHAR(19)||’01’||CHAR(19)||’24’
			//위치A(GATE 번호 - 1/2/3), 위치B(좌,우 - 1/2), 위치C(X축 위치), 위치D(Y축 위치)
			result = this.getGb()+(char)19+this.getEntYmd()+(char)19+this.targetNo+(char)19+this.getLineNo()+(char)19+this.getRackNo()+(char)19+this.getColume()+(char)19+this.getFloor();
		} else if (StringUtils.equals("OUT", this.getGb())) {
			result = this.getGb()+(char)19+this.getEntYmd()+(char)19+this.targetNo+(char)19+this.getResult()+(char)19+this.getRemark()+(char)19+this.getLineNo()+(char)19+this.getRackNo()+(char)19+this.getColume()+(char)19+this.getFloor()+(char)19+this.getSeq();
		} else {
			result = this.getGb()+(char)19+this.getEntYmd()+(char)19+this.targetNo+(char)19+this.getResult()+(char)19+this.getRemark()+(char)19+this.getSeq();
		}
		return result;
	}
}
