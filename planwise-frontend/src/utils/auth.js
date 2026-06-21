const TOKEN_KEY = 'planwise_token'
const USER_KEY = 'planwise_userInfo'

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken(token) {
  localStorage.setItem(TOKEN_KEY, token)
}

export function removeToken() {
  localStorage.removeItem(TOKEN_KEY)
}

export function getUserInfo() {
  const info = localStorage.getItem(USER_KEY)
  return info ? JSON.parse(info) : {}
}

export function setUserInfo(info) {
  localStorage.setItem(USER_KEY, JSON.stringify(info))
}

export function removeUserInfo() {
  localStorage.removeItem(USER_KEY)
}
