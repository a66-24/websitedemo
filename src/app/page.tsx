import { Metadata } from 'next'
import Hero from '@/components/sections/Hero'
import CoreServices from '@/components/sections/CoreServices'
import ValueAddedServices from '@/components/sections/ValueAddedServices'
import Features from '@/components/sections/Features'
import Cooperation from '@/components/sections/Cooperation'

export const metadata: Metadata = {
  title: '企业数字化服务解决方案',
  description: '提供专业的企业建站、数字化办公等服务'
}

export default function Home() {
  return (
    <main>
      <Hero />
      <CoreServices />
      <ValueAddedServices />
      <Features />
      <Cooperation />
    </main>
  )
}
