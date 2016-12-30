package com.stt.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.github.pagehelper.PageInfo;
import com.stt.entity.ClientInfo;
import com.stt.service.QueryLogService;
import com.stt.util.HttpUtil;
import net.sf.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import com.stt.entity.Scuser;
import com.stt.entity.QueryLog;
import com.stt.service.ScuserService;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;


/**
 * Created by Administrator on 2016/12/15.
 */
@Controller
@RequestMapping("/scuser")
public class ScuserController {
    @Resource
    private ScuserService scuserService;
    @Resource
    private QueryLogService queryLogService;
    
    @RequestMapping("/show")
    public String show(HttpServletRequest request, Model model){
        int id = Integer.parseInt(request.getParameter("id"));
        Scuser scuser = scuserService.findById(id);
        model.addAttribute("scuser",scuser);
        return "showUser";
    }
    
    /**
	 * 查询用户列表
	 * @return
	 */
	@RequestMapping(value = "/userList")
	@ResponseBody
	public Object getUserList(HttpServletRequest request, Model model){
        String name = request.getParameter("name");
        int pageNo = Integer.parseInt(request.getParameter("page"));
        int pageSize = Integer.parseInt(request.getParameter("rows"));
        if(StringUtils.isEmpty(name)){
            return null;
        }
        if(pageNo == 1){
            //初始化ClientInfo对象，唯一的参数：request.getHeader("user-agent")
            ClientInfo clientInfo = new ClientInfo(request.getHeader("user-agent"));
            //获取核心浏览器名称并保存到登录信息对象（loginlog）的相应属性中
            String exploreName = clientInfo.getExplorerName();
            String exploreVer = clientInfo.getExplorerVer();
            String explorePlug = clientInfo.getExplorerPlug();
            String OSName = clientInfo.getOSName();
            String OSVer = clientInfo.getOSVer();
            String ip = HttpUtil.getIpAddr(request); //：获得客户端的ip地址
            String host = request.getRemoteHost(); //获得客户端电脑的名字，若失败，则返回客户端电脑的ip地址
            String address = HttpUtil.getAddressByIP(ip);
            // 记录查询日志
        	QueryLog log = new QueryLog();
        	log.setName(name);
            log.setExplorename(exploreName);
            log.setExploreplug(explorePlug);
            log.setExplorever(exploreVer);
            log.setOsname(OSName);
            log.setOsver(OSVer);
            log.setHost(host);
            log.setAddress(address);
            log.setIp(ip);
        	try {
                queryLogService.insertLog(log);
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
        }
        PageInfo<Scuser> page = scuserService.queryByPage(name,pageNo,pageSize);
        return page;
	}

    /**
     * 根据用户名统计男女比例
     * @return
     */
    @RequestMapping(value = "/selectSex")
    @ResponseBody
    public Object selectSex(HttpServletRequest request, Model model){
        String name = request.getParameter("name");
        if(StringUtils.isEmpty(name)){
            return null;
        }
        List<Map<String, Object>> sexList = scuserService.selectSexPie(name);
        JSONArray json = JSONArray.fromObject(sexList);
        return json;
    }

    /**
     * 根据用户名统计年龄分布
     * @return
     */
    @RequestMapping(value = "/selectBir")
    @ResponseBody
    public Object selectBir(HttpServletRequest request, Model model){
        String name = request.getParameter("name");
        if(StringUtils.isEmpty(name)){
            return null;
        }
        List<Map<String, Object>> birList = scuserService.selectBirLine(name);
        JSONArray json = JSONArray.fromObject(birList);
        return json;
    }
    
    /**
     * 根据用户名统计地域分布
     * @return
     */
    @RequestMapping(value = "/selectMap")
    @ResponseBody
    public Object selectMap(HttpServletRequest request){
        String name = request.getParameter("name");
        if(StringUtils.isEmpty(name)){
            return null;
        }
        List<Map<String, Object>> mapList = scuserService.selectMap(name);
        JSONArray json = JSONArray.fromObject(mapList);
        return json;
    }

    /**
     * 根据用户名统计城市分布
     * @return
     */
    @RequestMapping(value = "/selectCityMap")
    @ResponseBody
    public Object selectCityMap(HttpServletRequest request){
        String name = request.getParameter("name");
        String province = request.getParameter("province");
        if(StringUtils.isEmpty(name) || StringUtils.isEmpty(province)){
            return null;
        }
        List<Map<String, Object>> mapList = scuserService.selectCityMap(name,province);
        JSONArray json = JSONArray.fromObject(mapList);
        return json;
    }

    /**
     * 根据用户名统计排名
     * @return
     */
    @RequestMapping(value = "/selectRank")
    @ResponseBody
    public Object selectRank(HttpServletRequest request){
        String name = request.getParameter("name");
        if(StringUtils.isEmpty(name)){
            return null;
        }
        Map<String, Object> mapList = scuserService.selectRank(name);
        JSONArray json = JSONArray.fromObject(mapList);
        return json;
    }
}
