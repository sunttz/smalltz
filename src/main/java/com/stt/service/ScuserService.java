package com.stt.service;

import com.github.pagehelper.PageInfo;
import com.stt.entity.Scuser;

import java.util.List;
import java.util.Map;

public interface ScuserService {

	public Scuser findById(int id);
	
	PageInfo<Scuser> queryByPage(String name,Integer pageNo,Integer pageSize);

	public List<Map<String, Object>> selectSexPie(String name);
}
