<template>
  <SideNav>
    <div class="flex-1 flex flex-col">
    <!-- Header -->
    <div class="bg-white border-b border-gray-200 px-6 py-4">
      <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">My Tasks</h1>
          <p class="text-sm text-gray-600 mt-1">Manage your tasks and to-dos</p>
        </div>

        <div class="flex items-center gap-3 w-full sm:w-auto">
          <!-- View Toggle -->
          <div class="flex bg-gray-100 rounded-lg p-1">
            <button
              @click="taskView = 'calendar'"
              :class="[
                'px-3 py-1.5 rounded-md text-sm font-medium transition',
                taskView === 'calendar'
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-600 hover:text-gray-900'
              ]"
              title="Calendar View"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </button>
            <button
              @click="taskView = 'list'"
              :class="[
                'px-3 py-1.5 rounded-md text-sm font-medium transition',
                taskView === 'list'
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-600 hover:text-gray-900'
              ]"
              title="List View"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
              </svg>
            </button>
            <button
              @click="taskView = 'table'"
              :class="[
                'px-3 py-1.5 rounded-md text-sm font-medium transition',
                taskView === 'table'
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-600 hover:text-gray-900'
              ]"
              title="Table View"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
            </button>
          </div>

          <button
            @click="openAddTaskDrawer"
            class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition flex items-center gap-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Add Task
          </button>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="p-6">
      <!-- Calendar View -->
      <TaskCalendar
        v-if="taskView === 'calendar'"
        :tasks="tasks"
        @edit="handleEditTask"
        @dateSelected="handleDateSelected"
      />

      <!-- List View -->
      <TaskList
        v-if="taskView === 'list'"
        :tasks="tasks"
        @edit="handleEditTask"
        @delete="handleDeleteTask"
        @updateStatus="handleUpdateTaskStatus"
      />

      <!-- Table View -->
      <TaskTable
        v-if="taskView === 'table'"
        :tasks="tasks"
        @edit="handleEditTask"
        @delete="handleDeleteTask"
        @updateStatus="handleUpdateTaskStatus"
      />
    </div>

    <!-- Task Drawer -->
    <TaskDrawer
      :is-open="isTaskDrawerOpen"
      :mode="taskDrawerMode"
      :task="selectedTask"
      :default-date="selectedDate"
      @close="closeTaskDrawer"
      @submit="handleAddTask"
      @update="handleUpdateTask"
    />
    </div>
  </SideNav>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useTasks, Task } from '../composables/useTasks'
import SideNav from '../components/SideNav.vue'
import TaskCalendar from '../components/TaskCalendar.vue'
import TaskList from '../components/TaskList.vue'
import TaskTable from '../components/TaskTable.vue'
import TaskDrawer from '../components/TaskDrawer.vue'

const { tasks, createTask, updateTask, deleteTask } = useTasks()

// Task state
const taskView = ref<'calendar' | 'list' | 'table'>('calendar')
const isTaskDrawerOpen = ref(false)
const taskDrawerMode = ref<'add' | 'edit'>('add')
const selectedTask = ref<Task | null>(null)
const selectedDate = ref<string>('')

// Task handlers
const openAddTaskDrawer = () => {
  taskDrawerMode.value = 'add'
  selectedTask.value = null
  selectedDate.value = ''
  isTaskDrawerOpen.value = true
}

const handleAddTask = async (data: Omit<Task, 'id' | 'createdAt' | 'updatedAt'>) => {
  await createTask(data)
}

const handleEditTask = (task: Task) => {
  taskDrawerMode.value = 'edit'
  selectedTask.value = task
  isTaskDrawerOpen.value = true
}

const handleUpdateTask = async (id: number, data: Partial<Omit<Task, 'id' | 'createdAt'>>) => {
  await updateTask(id, data)
}

const handleDeleteTask = async (id: number) => {
  await deleteTask(id)
}

const handleUpdateTaskStatus = async (id: number, status: Task['status']) => {
  await updateTask(id, { status })
}

const handleDateSelected = (date: string) => {
  selectedDate.value = date
  openAddTaskDrawer()
}

const closeTaskDrawer = () => {
  isTaskDrawerOpen.value = false
}
</script>
