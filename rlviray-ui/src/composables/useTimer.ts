import { ref, computed } from 'vue'

export interface TimeEntry {
  id: number
  taskId?: number
  taskTitle: string
  startTime: string
  endTime?: string
  duration: number // in seconds
  description?: string
  createdAt: string
}

const timeEntries = ref<TimeEntry[]>([])
const activeEntry = ref<TimeEntry | null>(null)
const elapsedTime = ref(0) // Current elapsed time in seconds
let timerInterval: number | null = null
const isInitialized = ref(false)

export function useTimer() {
  const loadTimeEntries = () => {
    // TODO: Replace with actual API call
    const storedEntries = localStorage.getItem('timeEntries')
    const storedActive = localStorage.getItem('activeTimeEntry')

    if (storedEntries) {
      timeEntries.value = JSON.parse(storedEntries)
    } else {
      // Initialize with dummy data
      const now = new Date()
      const yesterday = new Date(now)
      yesterday.setDate(yesterday.getDate() - 1)

      timeEntries.value = [
        {
          id: 1,
          taskTitle: 'Review project proposal',
          startTime: yesterday.toISOString(),
          endTime: new Date(yesterday.getTime() + 3600000).toISOString(), // 1 hour
          duration: 3600,
          description: 'Reviewed Q1 proposal',
          createdAt: yesterday.toISOString()
        },
        {
          id: 2,
          taskTitle: 'Code review',
          startTime: yesterday.toISOString(),
          endTime: new Date(yesterday.getTime() + 1800000).toISOString(), // 30 minutes
          duration: 1800,
          createdAt: yesterday.toISOString()
        }
      ]
      saveToStorage()
    }

    if (storedActive) {
      activeEntry.value = JSON.parse(storedActive)
      // Calculate elapsed time since start
      if (activeEntry.value) {
        const start = new Date(activeEntry.value.startTime).getTime()
        const now = Date.now()
        elapsedTime.value = Math.floor((now - start) / 1000)
        startTimer()
      }
    }
  }

  const saveToStorage = () => {
    localStorage.setItem('timeEntries', JSON.stringify(timeEntries.value))
    if (activeEntry.value) {
      localStorage.setItem('activeTimeEntry', JSON.stringify(activeEntry.value))
    } else {
      localStorage.removeItem('activeTimeEntry')
    }
  }

  const startTimer = () => {
    if (timerInterval) return

    timerInterval = window.setInterval(() => {
      elapsedTime.value++
    }, 1000)
  }

  const stopTimer = () => {
    if (timerInterval) {
      clearInterval(timerInterval)
      timerInterval = null
    }
  }

  const startTimeEntry = async (taskTitle: string, taskId?: number, description?: string): Promise<TimeEntry> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      // Stop any active timer first
      if (activeEntry.value) {
        stopTimeEntry()
      }

      const newEntry: TimeEntry = {
        id: Date.now(),
        taskId,
        taskTitle,
        startTime: new Date().toISOString(),
        duration: 0,
        description,
        createdAt: new Date().toISOString()
      }

      activeEntry.value = newEntry
      elapsedTime.value = 0
      startTimer()
      saveToStorage()
      resolve(newEntry)
    })
  }

  const stopTimeEntry = async (): Promise<TimeEntry | null> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      if (!activeEntry.value) {
        resolve(null)
        return
      }

      stopTimer()

      const completedEntry: TimeEntry = {
        ...activeEntry.value,
        endTime: new Date().toISOString(),
        duration: elapsedTime.value
      }

      timeEntries.value.unshift(completedEntry)
      activeEntry.value = null
      elapsedTime.value = 0
      saveToStorage()
      resolve(completedEntry)
    })
  }

  const deleteTimeEntry = async (id: number): Promise<boolean> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = timeEntries.value.findIndex(entry => entry.id === id)
      if (index !== -1) {
        timeEntries.value.splice(index, 1)
        saveToStorage()
        resolve(true)
      } else {
        resolve(false)
      }
    })
  }

  const formatDuration = (seconds: number): string => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60

    if (hours > 0) {
      return `${hours}h ${minutes}m ${secs}s`
    } else if (minutes > 0) {
      return `${minutes}m ${secs}s`
    } else {
      return `${secs}s`
    }
  }

  const getTotalTimeToday = (): number => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    return timeEntries.value
      .filter(entry => {
        const entryDate = new Date(entry.startTime)
        entryDate.setHours(0, 0, 0, 0)
        return entryDate.getTime() === today.getTime()
      })
      .reduce((total, entry) => total + entry.duration, 0)
  }

  const getTotalTimeThisWeek = (): number => {
    const now = new Date()
    const startOfWeek = new Date(now)
    startOfWeek.setDate(now.getDate() - now.getDay())
    startOfWeek.setHours(0, 0, 0, 0)

    return timeEntries.value
      .filter(entry => new Date(entry.startTime) >= startOfWeek)
      .reduce((total, entry) => total + entry.duration, 0)
  }

  // Initialize on first use
  if (!isInitialized.value) {
    loadTimeEntries()
    isInitialized.value = true
  }

  return {
    timeEntries: computed(() => timeEntries.value),
    activeEntry: computed(() => activeEntry.value),
    elapsedTime: computed(() => elapsedTime.value),
    isTimerRunning: computed(() => activeEntry.value !== null),
    startTimeEntry,
    stopTimeEntry,
    deleteTimeEntry,
    formatDuration,
    getTotalTimeToday,
    getTotalTimeThisWeek,
    loadTimeEntries
  }
}
