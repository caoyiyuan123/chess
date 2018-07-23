package com.xiaocao.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Author: jack
 * @Create: 2018-07-21-19:50
 * @Desc:
 **/
@Controller
public class DemoController {

    @RequestMapping("/chess")
    public String chess(){
        return "chess";
    }
}
