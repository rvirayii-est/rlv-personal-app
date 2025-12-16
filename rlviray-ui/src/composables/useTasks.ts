import { ref, computed } from 'vue'

export interface Task {
  id: number
  title: string
  description?: string
  dueDate: string // ISO date string
  status: 'pending' | 'in-progress' | 'completed'
  priority: 'low' | 'medium' | 'high'
  category?: string
  createdAt: string
  updatedAt: string
}

const tasks = ref<Task[]>([])
const isInitialized = ref(false)

export function useTasks() {
  const loadTasks = () => {
    // TODO: Replace with actual API call
    const storedTasks = localStorage.getItem('userTasks')
    if (storedTasks) {
      tasks.value = JSON.parse(storedTasks)
    } else {
      // Initialize with dummy data
      const today = new Date()
      const tomorrow = new Date(today)
      tomorrow.setDate(tomorrow.getDate() + 1)
      const nextWeek = new Date(today)
      nextWeek.setDate(nextWeek.getDate() + 7)
      const yesterday = new Date(today)
      yesterday.setDate(yesterday.getDate() - 1)

      tasks.value = [
        {
          id: 1,
          title: 'Review project proposal',
          description: 'Go through the Q1 project proposal and provide feedback',
          dueDate: today.toISOString().split('T')[0],
          status: 'in-progress',
          priority: 'high',
          category: 'Work',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 2,
          title: 'Team meeting preparation',
          description: 'Prepare slides for weekly team sync',
          dueDate: tomorrow.toISOString().split('T')[0],
          status: 'pending',
          priority: 'medium',
          category: 'Work',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 3,
          title: 'Update documentation',
          description: 'Update API documentation with new endpoints',
          dueDate: nextWeek.toISOString().split('T')[0],
          status: 'pending',
          priority: 'low',
          category: 'Development',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 4,
          title: 'Code review',
          description: 'Review pull requests from team members',
          dueDate: yesterday.toISOString().split('T')[0],
          status: 'completed',
          priority: 'medium',
          category: 'Development',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 5,
          title: 'Client presentation',
          description: 'Present project progress to client stakeholders',
          dueDate: today.toISOString().split('T')[0],
          status: 'pending',
          priority: 'high',
          category: 'Work',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ]
      saveToStorage()
    }
  }

  const saveToStorage = () => {
    localStorage.setItem('userTasks', JSON.stringify(tasks.value))
  }

  const createTask = async (taskData: Omit<Task, 'id' | 'createdAt' | 'updatedAt'>): Promise<Task> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const newTask: Task = {
        ...taskData,
        id: Date.now(),
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
      tasks.value.push(newTask)
      saveToStorage()
      resolve(newTask)
    })
  }

  const updateTask = async (id: number, taskData: Partial<Omit<Task, 'id' | 'createdAt'>>): Promise<Task | null> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = tasks.value.findIndex(task => task.id === id)
      if (index !== -1) {
        tasks.value[index] = {
          ...tasks.value[index],
          ...taskData,
          updatedAt: new Date().toISOString()
        }
        saveToStorage()
        resolve(tasks.value[index])
      } else {
        resolve(null)
      }
    })
  }

  const deleteTask = async (id: number): Promise<boolean> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = tasks.value.findIndex(task => task.id === id)
      if (index !== -1) {
        tasks.value.splice(index, 1)
        saveToStorage()
        resolve(true)
      } else {
        resolve(false)
      }
    })
  }

  const getTaskById = (id: number): Task | undefined => {
    return tasks.value.find(task => task.id === id)
  }

  const getTasksByDate = (date: string): Task[] => {
    return tasks.value.filter(task => task.dueDate === date)
  }

  const getTasksByStatus = (status: Task['status']): Task[] => {
    return tasks.value.filter(task => task.status === status)
  }

  const getTasksByPriority = (priority: Task['priority']): Task[] => {
    return tasks.value.filter(task => task.priority === priority)
  }

  // Initialize on first use
  if (!isInitialized.value) {
    loadTasks()
    isInitialized.value = true
  }

  return {
    tasks: computed(() => tasks.value),
    createTask,
    updateTask,
    deleteTask,
    getTaskById,
    getTasksByDate,
    getTasksByStatus,
    getTasksByPriority,
    loadTasks
  }
}
