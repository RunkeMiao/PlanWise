package top.xiaocaohub.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 把 /images/avatar/ 映射到 ./uploads/avatars/
        registry.addResourceHandler("/images/avatar/**")
                .addResourceLocations("file:./uploads/avatars/");
    }
}
