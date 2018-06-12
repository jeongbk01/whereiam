/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package bk.api.gps.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import bk.api.gps.service.ApiVO;
import bk.api.gps.service.EgovApiService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Class Name : EgovApiServiceImpl.java
 * @Description : Api Business Implement Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Service("apiService")
public class EgovApiServiceImpl extends EgovAbstractServiceImpl implements EgovApiService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovApiServiceImpl.class);

	// TODO mybatis 사용
	@Resource(name="apiMapper")
	private ApiMapper apiMapper;
	
	@Override
	public void insertCallApi(ApiVO apiVO) {
		apiMapper.insertCallApi(apiVO);
	}
	
	@Override
	public void insertBackupData() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());
		
		String sql = "CREATE TABLE GPS_INFO_BAK_"+strToday+" AS ";
		sql+= "SELECT * FROM GPS_INFO WHERE TO_CHAR(TO_DATE(REG_DT,'YYYYMMDD HH24MISS'),'YYYYMMDD') BETWEEN TO_CHAR(SYSDATE-10,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD')";
		apiMapper.insertBackupData(sql);
		apiMapper.deleteData();
	}	

	@Override
	public Map<String, Object> selectApiInfo(ApiVO apiVO) {
		Map<String, Object> resultMap = new HashMap<String, Object>(); 
		
		List<?> resultList = apiMapper.selectApiList(apiVO);
		int resultTotCnt = apiMapper.selectApiListTotCnt(apiVO);

		resultMap.put("resultList", resultList);
		resultMap.put("resultTotCnt", resultTotCnt);
		return resultMap;
	}

}