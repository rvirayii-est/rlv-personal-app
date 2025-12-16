import { ref, computed } from 'vue'

interface User {
  id: number
  name: string
  email: string
}

const isAuthenticated = ref<boolean>(false)
const currentUser = ref<User | null>(null)

export function useAuth() {
  const login = async (email: string, password: string): Promise<boolean> => {
    // TODO: Replace with actual API call
    // Simulating API call with dummy data
    return new Promise((resolve) => {
      setTimeout(() => {
        // Dummy login logic - accept any email/password for now
        if (email && password) {
          currentUser.value = {
            id: 1,
            name: 'John Doe',
            email: email
          }
          isAuthenticated.value = true
          // Store auth state in localStorage for persistence
          localStorage.setItem('isAuthenticated', 'true')
          localStorage.setItem('currentUser', JSON.stringify(currentUser.value))
          resolve(true)
        } else {
          resolve(false)
        }
      }, 500)
    })
  }

  const logout = () => {
    currentUser.value = null
    isAuthenticated.value = false
    localStorage.removeItem('isAuthenticated')
    localStorage.removeItem('currentUser')
  }

  const checkAuth = () => {
    // Check if user is authenticated from localStorage
    const authStatus = localStorage.getItem('isAuthenticated')
    const userData = localStorage.getItem('currentUser')

    if (authStatus === 'true' && userData) {
      isAuthenticated.value = true
      currentUser.value = JSON.parse(userData)
    }
  }

  // Initialize auth state on first use
  if (!isAuthenticated.value) {
    checkAuth()
  }

  return {
    isAuthenticated: computed(() => isAuthenticated.value),
    currentUser: computed(() => currentUser.value),
    login,
    logout,
    checkAuth
  }
}
