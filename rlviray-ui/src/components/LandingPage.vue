<script setup lang="ts">
import { ref } from 'vue'

interface Service {
  id: number
  title: string
  description: string
  icon: string
}

interface Feature {
  id: number
  title: string
  description: string
  icon: string
}

interface ValueProp {
  id: number
  title: string
  description: string
  image: string
}

interface WorkCard {
  id: number
  number: string
  title: string
  description: string
  cta: string
  image: string
}

interface TeamMember {
  id: number
  name: string
  role: string
  image: string
}

interface Partner {
  id: number
  name: string
  logo: string
}

// Mock data
const services = ref<Service[]>([
  {
    id: 1,
    title: 'AI Development',
    description: 'Build intelligent solutions with cutting-edge AI and machine learning technologies.',
    icon: '🤖'
  },
  {
    id: 2,
    title: 'Web App Development',
    description: 'Create powerful, scalable web applications tailored to your business needs.',
    icon: '🌐'
  },
  {
    id: 3,
    title: 'Mobile App Development',
    description: 'Design and develop native and cross-platform mobile applications.',
    icon: '📱'
  },
  {
    id: 4,
    title: 'Product Design',
    description: 'Craft beautiful, user-centric designs that enhance user experience.',
    icon: '🎨'
  },
  {
    id: 5,
    title: 'CMS Solutions',
    description: 'Implement flexible content management systems for easy content control.',
    icon: '📝'
  }
])

const features = ref<Feature[]>([
  {
    id: 1,
    title: 'Content Quality',
    description: 'High-quality content that engages and converts',
    icon: '✨'
  },
  {
    id: 2,
    title: 'Security',
    description: 'Enterprise-grade security for your peace of mind',
    icon: '🔒'
  },
  {
    id: 3,
    title: 'Analytics & Tracking',
    description: 'Comprehensive insights into your metrics',
    icon: '📊'
  },
  {
    id: 4,
    title: 'Performance',
    description: 'Optimized for speed and efficiency',
    icon: '⚡'
  },
  {
    id: 5,
    title: 'UX Design',
    description: 'Intuitive interfaces users love',
    icon: '💎'
  },
  {
    id: 6,
    title: 'SEO Optimization',
    description: 'Rank higher in search results',
    icon: '🎯'
  }
])

const valueProps = ref<ValueProp[]>([
  {
    id: 1,
    title: 'Innovation',
    description: 'We leverage the latest technologies and methodologies to deliver cutting-edge solutions that keep you ahead of the competition.',
    image: '💡'
  },
  {
    id: 2,
    title: 'Reliability',
    description: 'Our proven track record and commitment to quality ensure that your projects are delivered on time and exceed expectations.',
    image: '🛡️'
  },
  {
    id: 3,
    title: 'Customer-Centric',
    description: 'Your success is our priority. We work closely with you to understand your needs and deliver solutions that drive results.',
    image: '🤝'
  },
  {
    id: 4,
    title: 'Uniqueness',
    description: 'Every solution we create is tailored to your specific requirements, ensuring a unique product that stands out.',
    image: '⭐'
  }
])

const workCards = ref<WorkCard[]>([
  {
    id: 1,
    number: '01',
    title: 'Portfolio',
    description: 'Explore our showcase of successful projects and see how we turn ideas into reality.',
    cta: 'View Portfolio',
    image: '🎯'
  },
  {
    id: 2,
    number: '02',
    title: 'Hire a Developer',
    description: 'Get access to skilled developers who can bring your vision to life.',
    cta: 'Hire Now',
    image: '👨‍💻'
  },
  {
    id: 3,
    number: '03',
    title: 'Developer Program',
    description: 'Join our community of talented developers and grow your skills.',
    cta: 'Learn More',
    image: '🚀'
  },
  {
    id: 4,
    number: '04',
    title: 'Careers',
    description: 'Be part of our team and work on exciting projects with cutting-edge technologies.',
    cta: 'View Openings',
    image: '💼'
  }
])

const admins = ref<TeamMember[]>([
  { id: 1, name: 'John Doe', role: 'CEO & Founder', image: '👨‍💼' },
  { id: 2, name: 'Jane Smith', role: 'CTO', image: '👩‍💼' },
  { id: 3, name: 'Mike Johnson', role: 'COO', image: '👨‍💼' },
  { id: 4, name: 'Sarah Williams', role: 'CFO', image: '👩‍💼' },
  { id: 5, name: 'David Brown', role: 'VP Engineering', image: '👨‍💼' },
  { id: 6, name: 'Emily Davis', role: 'VP Design', image: '👩‍💼' },
  { id: 7, name: 'Chris Wilson', role: 'VP Product', image: '👨‍💼' },
  { id: 8, name: 'Lisa Anderson', role: 'VP Marketing', image: '👩‍💼' },
  { id: 9, name: 'Tom Martinez', role: 'VP Sales', image: '👨‍💼' },
  { id: 10, name: 'Amy Taylor', role: 'VP HR', image: '👩‍💼' },
  { id: 11, name: 'Robert Lee', role: 'VP Operations', image: '👨‍💼' }
])

const mentors = ref<TeamMember[]>([
  { id: 1, name: 'Alex Chen', role: 'Frontend Mentor', image: '👨‍🏫' },
  { id: 2, name: 'Maria Garcia', role: 'Backend Mentor', image: '👩‍🏫' },
  { id: 3, name: 'Kevin Park', role: 'Mobile Mentor', image: '👨‍🏫' },
  { id: 4, name: 'Sophie Turner', role: 'Design Mentor', image: '👩‍🏫' },
  { id: 5, name: 'James Wilson', role: 'DevOps Mentor', image: '👨‍🏫' },
  { id: 6, name: 'Rachel Green', role: 'QA Mentor', image: '👩‍🏫' },
  { id: 7, name: 'Daniel Kim', role: 'AI/ML Mentor', image: '👨‍🏫' },
  { id: 8, name: 'Olivia Brown', role: 'Product Mentor', image: '👩‍🏫' },
  { id: 9, name: 'Nathan Scott', role: 'Security Mentor', image: '👨‍🏫' },
  { id: 10, name: 'Isabella Lopez', role: 'Data Mentor', image: '👩‍🏫' },
  { id: 11, name: 'Ethan Hunt', role: 'Cloud Mentor', image: '👨‍🏫' }
])

const teamMembers = ref<TeamMember[]>([
  { id: 1, name: 'Developer 1', role: 'Full Stack Developer', image: '👨‍💻' },
  { id: 2, name: 'Developer 2', role: 'Frontend Developer', image: '👩‍💻' },
  { id: 3, name: 'Developer 3', role: 'Backend Developer', image: '👨‍💻' },
  { id: 4, name: 'Developer 4', role: 'Mobile Developer', image: '👩‍💻' },
  { id: 5, name: 'Developer 5', role: 'UI/UX Designer', image: '👨‍💻' },
  { id: 6, name: 'Developer 6', role: 'DevOps Engineer', image: '👩‍💻' },
  { id: 7, name: 'Developer 7', role: 'QA Engineer', image: '👨‍💻' },
  { id: 8, name: 'Developer 8', role: 'Data Scientist', image: '👩‍💻' },
  { id: 9, name: 'Developer 9', role: 'Product Manager', image: '👨‍💻' },
  { id: 10, name: 'Developer 10', role: 'Scrum Master', image: '👩‍💻' },
  { id: 11, name: 'Developer 11', role: 'Tech Lead', image: '👨‍💻' },
  { id: 12, name: 'Developer 12', role: 'Solution Architect', image: '👩‍💻' }
])

const partners = ref<Partner[]>([
  { id: 1, name: 'TechCorp', logo: '🏢' },
  { id: 2, name: 'InnovateLabs', logo: '🔬' },
  { id: 3, name: 'CloudSystems', logo: '☁️' },
  { id: 4, name: 'DataFlow', logo: '📊' },
  { id: 5, name: 'AIVentures', logo: '🤖' },
  { id: 6, name: 'MobileTech', logo: '📱' },
  { id: 7, name: 'SecureNet', logo: '🔐' },
  { id: 8, name: 'DesignStudio', logo: '🎨' },
  { id: 9, name: 'CodeMasters', logo: '💻' },
  { id: 10, name: 'WebPro', logo: '🌐' },
  { id: 11, name: 'AppFactory', logo: '🏭' },
  { id: 12, name: 'DevHub', logo: '🚀' }
])

const mobileMenuOpen = ref(false)
</script>

<style scoped>
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

.service-card {
  animation: fadeInUp 0.6s ease-out forwards;
  opacity: 0;
}

.service-card:nth-child(1) { animation-delay: 0.1s; }
.service-card:nth-child(2) { animation-delay: 0.2s; }
.service-card:nth-child(3) { animation-delay: 0.3s; }
.service-card:nth-child(4) { animation-delay: 0.4s; }
.service-card:nth-child(5) { animation-delay: 0.5s; }

.group:hover .service-icon {
  animation: float 2s ease-in-out infinite;
}
</style>

<template>
  <div class="min-h-screen bg-gray-900 text-white">
    <!-- Decorative background elements -->
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-0 right-0 w-96 h-96 bg-purple-600/20 rounded-full blur-3xl"></div>
      <div class="absolute bottom-0 left-0 w-96 h-96 bg-cyan-600/20 rounded-full blur-3xl"></div>
    </div>

    <!-- Navigation -->
    <nav class="sticky top-0 z-50 bg-gray-900/80 backdrop-blur-lg border-b border-white/10">
      <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <div class="flex items-center">
            <span class="text-2xl font-bold bg-gradient-to-r from-purple-400 via-purple-300 to-cyan-300 bg-clip-text text-transparent">
              RLViray
            </span>
          </div>
          <div class="hidden md:flex items-center space-x-8">
            <a href="#services" class="text-white/75 hover:text-white transition-colors">Services</a>
            <a href="#features" class="text-white/75 hover:text-white transition-colors">Features</a>
            <a href="#team" class="text-white/75 hover:text-white transition-colors">Team</a>
            <a href="#partners" class="text-white/75 hover:text-white transition-colors">Partners</a>
            <router-link to="/login" class="text-white/75 hover:text-white transition-colors">Login</router-link>
            <button class="bg-gradient-to-r from-purple-600 to-purple-700 text-white px-6 py-2 rounded-full hover:from-purple-700 hover:to-purple-800 transition-all">
              Get Started
            </button>
          </div>
          <button @click="mobileMenuOpen = !mobileMenuOpen" class="md:hidden text-white">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </button>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative pt-20 pb-32 px-4 sm:px-6 lg:px-8 overflow-hidden">
      <div class="absolute inset-0 bg-gradient-to-b from-purple-900/20 to-transparent"></div>
      <div class="relative max-w-6xl mx-auto text-center">
        <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold mb-6 leading-tight">
          <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
            Turn your ideas into
          </span>
          <br />
          <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
            profitable digital products
          </span>
        </h1>
        <p class="text-xl md:text-2xl text-white/75 mb-12 max-w-3xl mx-auto">
          We help businesses transform their vision into reality with cutting-edge technology solutions
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <button class="bg-gradient-to-r from-purple-600 to-purple-700 text-white px-8 py-4 rounded-full text-lg font-semibold hover:from-purple-700 hover:to-purple-800 transition-all transform hover:scale-105 shadow-lg shadow-purple-500/20">
            Get Started Today
          </button>
          <button class="bg-white/10 backdrop-blur-sm text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white/20 transition-all border border-white/10">
            Learn More
          </button>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-20 px-4 sm:px-6 lg:px-8">
      <div class="max-w-6xl mx-auto">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold mb-4">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Our Services
            </span>
          </h2>
          <p class="text-xl text-white/70 max-w-2xl mx-auto">
            Comprehensive solutions for all your digital needs
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="service in services"
            :key="service.id"
            class="service-card group relative overflow-hidden bg-gradient-to-br from-white/5 to-white/10 backdrop-blur-sm p-8 rounded-2xl transition-all duration-500 border border-white/10 hover:border-purple-500/50 hover:shadow-2xl hover:shadow-purple-500/20 hover:-translate-y-2 cursor-pointer"
          >
            <!-- Gradient overlay on hover -->
            <div class="absolute inset-0 bg-gradient-to-br from-purple-600/10 to-cyan-600/10 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>

            <!-- Glow effect -->
            <div class="absolute -inset-1 bg-gradient-to-r from-purple-600 to-cyan-600 rounded-2xl blur opacity-0 group-hover:opacity-20 transition-opacity duration-500 -z-10"></div>

            <!-- Content -->
            <div class="relative z-10">
              <div class="service-icon text-5xl mb-4 transform group-hover:scale-110 group-hover:rotate-3 transition-transform duration-500">
                {{ service.icon }}
              </div>
              <h3 class="text-2xl font-semibold mb-3 group-hover:text-white transition-colors duration-300">
                {{ service.title }}
              </h3>
              <p class="text-white/70 group-hover:text-white/90 transition-colors duration-300">
                {{ service.description }}
              </p>
            </div>

            <!-- Decorative corner elements -->
            <div class="absolute top-0 right-0 w-20 h-20 bg-gradient-to-br from-purple-500/20 to-transparent rounded-bl-full opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
            <div class="absolute bottom-0 left-0 w-20 h-20 bg-gradient-to-tr from-cyan-500/20 to-transparent rounded-tr-full opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Grid -->
    <section id="features" class="py-20 px-4 sm:px-6 lg:px-8 bg-white/5">
      <div class="max-w-6xl mx-auto">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold mb-4">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Why Choose Us
            </span>
          </h2>
          <p class="text-xl text-white/70 max-w-2xl mx-auto">
            Features that set us apart from the competition
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="feature in features"
            :key="feature.id"
            class="bg-white/5 backdrop-blur-sm p-6 rounded-xl border border-white/10 hover:border-cyan-500/50 transition-all"
          >
            <div class="text-4xl mb-3">{{ feature.icon }}</div>
            <h3 class="text-xl font-semibold mb-2">{{ feature.title }}</h3>
            <p class="text-white/70 text-sm">{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Value Propositions -->
    <section class="py-20 px-4 sm:px-6 lg:px-8">
      <div class="max-w-6xl mx-auto">
        <div class="grid md:grid-cols-2 gap-8">
          <div
            v-for="prop in valueProps"
            :key="prop.id"
            class="group bg-gradient-to-br from-white/5 to-white/10 backdrop-blur-sm p-8 rounded-2xl border border-white/10 hover:border-purple-500/50 transition-all hover:shadow-xl hover:shadow-purple-500/10"
          >
            <div class="text-6xl mb-4">{{ prop.image }}</div>
            <h3 class="text-2xl font-bold mb-3">{{ prop.title }}</h3>
            <p class="text-white/70">{{ prop.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Work With Us Section -->
    <section class="py-20 px-4 sm:px-6 lg:px-8 bg-white/5">
      <div class="max-w-6xl mx-auto">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold mb-4">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Work With Us
            </span>
          </h2>
          <p class="text-xl text-white/70 max-w-2xl mx-auto">
            Multiple ways to collaborate and grow together
          </p>
        </div>

        <div class="grid md:grid-cols-2 gap-6">
          <div
            v-for="card in workCards"
            :key="card.id"
            class="group relative bg-white/5 backdrop-blur-sm rounded-2xl overflow-hidden border border-white/10 hover:border-purple-500/50 transition-all hover:shadow-xl hover:shadow-purple-500/20"
          >
            <div class="p-8">
              <div class="text-6xl font-bold text-white/10 mb-4">{{ card.number }}</div>
              <div class="text-5xl mb-4">{{ card.image }}</div>
              <h3 class="text-2xl font-bold mb-3">{{ card.title }}</h3>
              <p class="text-white/70 mb-6">{{ card.description }}</p>
              <button class="bg-gradient-to-r from-purple-600 to-purple-700 text-white px-6 py-3 rounded-full font-semibold hover:from-purple-700 hover:to-purple-800 transition-all group-hover:scale-105 transform">
                {{ card.cta }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Team Section -->
    <section id="team" class="py-20 px-4 sm:px-6 lg:px-8">
      <div class="max-w-6xl mx-auto">
        <!-- Admins -->
        <div class="mb-20">
          <h2 class="text-4xl font-bold mb-12 text-center">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Leadership Team
            </span>
          </h2>
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <div
              v-for="admin in admins"
              :key="admin.id"
              class="bg-white/5 backdrop-blur-sm p-6 rounded-xl border border-white/10 hover:border-purple-500/50 transition-all text-center"
            >
              <div class="text-5xl mb-3">{{ admin.image }}</div>
              <h4 class="font-semibold mb-1">{{ admin.name }}</h4>
              <p class="text-sm text-white/70">{{ admin.role }}</p>
            </div>
          </div>
        </div>

        <!-- Mentors -->
        <div class="mb-20">
          <h2 class="text-4xl font-bold mb-12 text-center">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Our Mentors
            </span>
          </h2>
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <div
              v-for="mentor in mentors"
              :key="mentor.id"
              class="bg-white/5 backdrop-blur-sm p-6 rounded-xl border border-white/10 hover:border-cyan-500/50 transition-all text-center"
            >
              <div class="text-5xl mb-3">{{ mentor.image }}</div>
              <h4 class="font-semibold mb-1">{{ mentor.name }}</h4>
              <p class="text-sm text-white/70">{{ mentor.role }}</p>
            </div>
          </div>
        </div>

        <!-- Team Members -->
        <div>
          <h2 class="text-4xl font-bold mb-12 text-center">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Our Team
            </span>
          </h2>
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <div
              v-for="member in teamMembers"
              :key="member.id"
              class="bg-white/5 backdrop-blur-sm p-6 rounded-xl border border-white/10 hover:border-purple-500/50 transition-all text-center"
            >
              <div class="text-5xl mb-3">{{ member.image }}</div>
              <h4 class="font-semibold mb-1">{{ member.name }}</h4>
              <p class="text-sm text-white/70">{{ member.role }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Partners Section -->
    <section id="partners" class="py-20 px-4 sm:px-6 lg:px-8 bg-white/5">
      <div class="max-w-6xl mx-auto">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold mb-4">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Trusted Partners
            </span>
          </h2>
          <p class="text-xl text-white/70 max-w-2xl mx-auto">
            Working with industry leaders to deliver excellence
          </p>
        </div>

        <div class="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-6">
          <div
            v-for="partner in partners"
            :key="partner.id"
            class="bg-white/5 backdrop-blur-sm p-6 rounded-xl border border-white/10 hover:border-purple-500/50 transition-all flex items-center justify-center"
          >
            <div class="text-center">
              <div class="text-4xl mb-2">{{ partner.logo }}</div>
              <p class="text-xs text-white/70">{{ partner.name }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-20 px-4 sm:px-6 lg:px-8">
      <div class="max-w-4xl mx-auto text-center">
        <div class="bg-gradient-to-r from-purple-600/20 to-cyan-600/20 backdrop-blur-sm p-12 rounded-3xl border border-white/10">
          <h2 class="text-4xl md:text-5xl font-bold mb-6">
            <span class="bg-gradient-to-r from-white via-purple-200 to-cyan-200 bg-clip-text text-transparent">
              Ready to Build Something Amazing?
            </span>
          </h2>
          <p class="text-xl text-white/75 mb-8">
            Let's turn your vision into reality. Get in touch with us today.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <button class="bg-gradient-to-r from-purple-600 to-purple-700 text-white px-8 py-4 rounded-full text-lg font-semibold hover:from-purple-700 hover:to-purple-800 transition-all transform hover:scale-105 shadow-lg shadow-purple-500/20">
              Start Your Project
            </button>
            <button class="bg-white/10 backdrop-blur-sm text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white/20 transition-all border border-white/10">
              Schedule a Call
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-black/50 backdrop-blur-sm py-12 px-4 sm:px-6 lg:px-8 border-t border-white/10">
      <div class="max-w-6xl mx-auto">
        <div class="grid md:grid-cols-4 gap-8 mb-8">
          <div>
            <h3 class="text-2xl font-bold mb-4 bg-gradient-to-r from-purple-400 to-cyan-400 bg-clip-text text-transparent">
              RLViray
            </h3>
            <p class="text-white/70 mb-4">
              Building the future with innovative digital solutions.
            </p>
            <div class="flex space-x-4">
              <a href="#" class="text-white/70 hover:text-purple-400 transition-colors">
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                </svg>
              </a>
              <a href="#" class="text-white/70 hover:text-purple-400 transition-colors">
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                </svg>
              </a>
              <a href="#" class="text-white/70 hover:text-purple-400 transition-colors">
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515a.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0a12.64 12.64 0 0 0-.617-1.25a.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057a19.9 19.9 0 0 0 5.993 3.03a.078.078 0 0 0 .084-.028a14.09 14.09 0 0 0 1.226-1.994a.076.076 0 0 0-.041-.106a13.107 13.107 0 0 1-1.872-.892a.077.077 0 0 1-.008-.128a10.2 10.2 0 0 0 .372-.292a.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.062 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127a12.299 12.299 0 0 1-1.873.892a.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028a19.839 19.839 0 0 0 6.002-3.03a.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.03zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419c0-1.333.956-2.419 2.157-2.419c1.21 0 2.176 1.096 2.157 2.42c0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419c0-1.333.955-2.419 2.157-2.419c1.21 0 2.176 1.096 2.157 2.42c0 1.333-.946 2.418-2.157 2.418z"/>
                </svg>
              </a>
            </div>
          </div>
          <div>
            <h4 class="font-semibold mb-4">Services</h4>
            <ul class="space-y-2 text-white/70">
              <li><a href="#" class="hover:text-white transition-colors">AI Development</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Web Development</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Mobile Apps</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Design</a></li>
            </ul>
          </div>
          <div>
            <h4 class="font-semibold mb-4">Company</h4>
            <ul class="space-y-2 text-white/70">
              <li><a href="#" class="hover:text-white transition-colors">About Us</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Careers</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Blog</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Contact</a></li>
            </ul>
          </div>
          <div>
            <h4 class="font-semibold mb-4">Resources</h4>
            <ul class="space-y-2 text-white/70">
              <li><a href="#" class="hover:text-white transition-colors">Documentation</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Privacy Policy</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Terms of Service</a></li>
              <li><a href="#" class="hover:text-white transition-colors">Support</a></li>
            </ul>
          </div>
        </div>
        <div class="border-t border-white/10 pt-8 text-center text-white/70">
          <p>&copy; 2025 RLViray. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>
