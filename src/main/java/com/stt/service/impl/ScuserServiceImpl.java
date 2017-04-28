package com.stt.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.stt.dao.ScuserDao;
import com.stt.entity.Scuser;
import com.stt.service.ScuserService;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("scuserServiceImpl")
public class ScuserServiceImpl implements ScuserService {

	@Resource
	private ScuserDao scuserDao;

	@Override
	public Scuser findById(int id) {
		return scuserDao.selectByPrimaryKey(id);
	}

	@Override
	public PageInfo<Scuser> queryByPage(String name, Integer pageNo, Integer pageSize) {
		pageNo = pageNo == null?1:pageNo;
	    pageSize = pageSize == null?20:pageSize;
	    PageHelper.startPage(pageNo, pageSize);
	    List<Scuser> list = scuserDao.selectUserByName(name);
	    //用PageInfo对结果进行包装
	    PageInfo<Scuser> page = new PageInfo<Scuser>(list);
	    return page;
	}

	@Override
	public List<Map<String, Object>> selectSexPie(String name) {
		return scuserDao.selectSexPie(name);
	}

	@Override
	public List<Map<String, Object>> selectBirLine(String name) {
		return scuserDao.selectBirLine(name);
	}

	@Override
	public List<Map<String, Object>> selectMap(String name) {
		return scuserDao.selectMap(name);
	}

	@Override
	public List<Map<String, Object>> selectCityMap(@Param("name") String name, @Param("province") String province) {
		return scuserDao.selectCityMap(name,province);
	}

	@Override
	public Map<String, Object> selectRank(String name) {
		return scuserDao.selectRank(name);
	}

	@Override
	public List<Map<String, Object>> top10() {
		return scuserDao.top10();
	}
}
