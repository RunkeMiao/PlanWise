import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getToken, setToken, removeToken, getUserInfo, setUserInfo, removeUserInfo } from '@/utils/auth'
import { login as loginApi, register as registerApi, getUserInfo as getUserInfoApi } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref(getToken())
  const userInfo = ref(getUserInfo())

  // 登录
  async function login(loginForm) {
    const res = await loginApi(loginForm)
    const { token: newToken, user } = res.data

    token.value = newToken
    userInfo.value = user

    setToken(newToken)
    setUserInfo(user)

    return res
  }

  // 注册
  async function register(registerForm) {
    return await registerApi(registerForm)
  }

  // 获取最新用户信息
  async function fetchUserInfo() {
    const res = await getUserInfoApi()
    userInfo.value = res.data
    setUserInfo(res.data)
    return res
  }

  // 退出登录
  function logout() {
    token.value = ''
    userInfo.value = {}
    removeToken()
    removeUserInfo()
  }

  return {
    token,
    userInfo,
    login,
    register,
    fetchUserInfo,
    logout
  }
})
