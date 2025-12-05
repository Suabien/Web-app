// src/main/java/com/trangsuc/MainLauncher.java
package com.trangsuc;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;

public class MainLauncher {
    public static void main(String[] args) throws Exception {
        // Get port from Railway environment variable
        String port = System.getenv("PORT");
        if (port == null || port.isEmpty()) {
            port = "8080";
        }
        
        // Create temp directory for Tomcat
        Path tempPath = Files.createTempDirectory("tomcat");
        String webappDirLocation = "src/main/webapp/";
        
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));
        tomcat.setBaseDir(tempPath.toString());
        
        // Disable SSL và các features không cần thiết
        tomcat.getConnector();
        
        // Add web application
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", 
            new File(webappDirLocation).getAbsolutePath());
        
        // Declare an alternative location for your "WEB-INF/classes" dir
        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(ctx);
        resources.addPreResources(new DirResourceSet(resources,
                "/WEB-INF/classes", additionWebInfClasses.getAbsolutePath(), "/"));
        ctx.setResources(resources);
        
        // Configure JSP
        tomcat.addServlet("", "jsp", new org.apache.jasper.servlet.JspServlet());
        
        System.out.println("Starting Tomcat on port: " + port);
        System.out.println("Application will be available at: http://localhost:" + port);
        
        tomcat.start();
        tomcat.getServer().await();
    }
}
