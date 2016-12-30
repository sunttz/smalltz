package com.stt.service;

import com.github.pagehelper.PageInfo;
import com.stt.entity.Scuser;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ScuserService {

	public Scuser findById(int id);
	
	PageInfo<Scuser> queryByPage(String name,Integer pageNo,Integer pageSize);

	public List<Map<String, Object>> selectSexPie(String name);

	/**
	 * 根据用户名统计年龄分布
	 * @param name
	 * @return
	 */
	List<Map<String, Object>> selectBirLine(String name);
	
	/**
     * 根据用户名统计地域分布
     * @param name
     * @return
     */
    List<Map<String, Object>> selectMap(@Param("name") String name);

	/**
	 * 根据用户名统计城市分布
	 * @param name
	 * @return
	 */
	List<Map<String, Object>> selectCityMap(@Param("name") String name,@Param("province") String province);
	
	/**
     * 根据用户名查询排名
     * @param name
     * @return
     */
    Map<String, Object> selectRank(@Param("name") String name);
}
