import { createRouter, createWebHistory } from 'vue-router'
import { getToken } from '@/utils/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/user/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/user/Register.vue'),
    meta: { title: '注册' }
  },
  {
    path: '/',
    component: () => import('@/components/layout/Layout.vue'),
    redirect: '/project',
    children: [
      {
        path: 'project',
        name: 'ProjectList',
        component: () => import('@/views/project/ProjectList.vue'),
        meta: { title: '项目列表' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/user/Profile.vue'),
        meta: { title: '个人信息' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫：未登录跳转到登录页
router.beforeEach((to, from, next) => {
  const token = getToken()

  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - PlanWise`
  }

  // 登录/注册页不需要认证
  if (to.path === '/login' || to.path === '/register') {
    // 已登录则跳转到首页
    if (token) {
      next('/')
    } else {
      next()
    }
    return
  }

  // 其他页面需要认证
  if (!token) {
    next('/login')
  } else {
    next()
  }
})

export default router
