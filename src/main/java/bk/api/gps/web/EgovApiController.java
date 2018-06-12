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
package bk.api.gps.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;

import bk.api.gps.service.ApiDefaultVO;
import bk.api.gps.service.ApiVO;
import bk.api.gps.service.EgovApiService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @Class Name : EgovApiController.java
 * @Description : EgovApi Controller Class
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

@Controller
public class EgovApiController {

	/** EgovApiService */
	@Resource(name = "apiService")
	private EgovApiService apiService;
	
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;
	
	@RequestMapping(value = "/egovApiList.do")
	public String selectApiList(@ModelAttribute("searchVO") ApiVO apiVO, ModelMap model) throws Exception {
		
		apiVO.setPageUnit(propertyService.getInt("pageUnit"));
		apiVO.setPageSize(propertyService.getInt("pageSize"));
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(apiVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(apiVO.getPageUnit());
		paginationInfo.setPageSize(apiVO.getPageSize());
		
		apiVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		apiVO.setLastIndex(paginationInfo.getLastRecordIndex());
		apiVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		
		Map<String, Object> apiMap = (Map<String, Object>)apiService.selectApiInfo(apiVO);
		
		int totCnt = Integer.parseInt(apiMap.get("resultTotCnt").toString());
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addAttribute("resultList", apiMap.get("resultList"));
		model.addAttribute("resultTotCnt", totCnt);
		model.addAttribute("searchVO", apiVO);
		model.addAttribute("paginationInfo", paginationInfo);
		return "egovApiList";
	}

	@RequestMapping("/callApi.do")
	public void callApi(ApiVO apiVO, @ModelAttribute("searchVO") ApiDefaultVO searchVO, SessionStatus status, HttpServletRequest req) throws Exception {
		apiService.insertCallApi(apiVO);
	}
}
