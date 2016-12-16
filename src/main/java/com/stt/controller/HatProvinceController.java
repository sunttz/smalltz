package com.stt.controller;

import com.stt.entity.HatProvince;
import com.stt.service.HatProvinceService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by Administrator on 2016/12/15.
 */
@Controller
@RequestMapping("/province")
public class HatProvinceController {
    @Resource
    private HatProvinceService hatProvinceService;

    @RequestMapping("/show")
    public String show(HttpServletRequest request, Model model){
        int sid = Integer.parseInt(request.getParameter("sid"));
        HatProvince hat = hatProvinceService.getHatProvinceById(sid);
        model.addAttribute("prov",hat);
        return "showUser";
    }
}
