package com.stt.entity;

import java.util.Date;

public class QueryLog {
    private Integer id;

    private String name;

    private Date date;

    private String explorename;

    private String explorever;

    private String exploreplug;

    private String osname;

    private String osver;

    private String ip;

    private String host;

    private String address;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getExplorename() {
        return explorename;
    }

    public void setExplorename(String explorename) {
        this.explorename = explorename == null ? null : explorename.trim();
    }

    public String getExplorever() {
        return explorever;
    }

    public void setExplorever(String explorever) {
        this.explorever = explorever == null ? null : explorever.trim();
    }

    public String getExploreplug() {
        return exploreplug;
    }

    public void setExploreplug(String exploreplug) {
        this.exploreplug = exploreplug == null ? null : exploreplug.trim();
    }

    public String getOsname() {
        return osname;
    }

    public void setOsname(String osname) {
        this.osname = osname == null ? null : osname.trim();
    }

    public String getOsver() {
        return osver;
    }

    public void setOsver(String osver) {
        this.osver = osver == null ? null : osver.trim();
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip == null ? null : ip.trim();
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host == null ? null : host.trim();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }
}