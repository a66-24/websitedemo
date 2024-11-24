import { Card } from '@/components/ui/card'

export default function CoreServices() {
  const services = [
    {
      title: '基础建站服务',
      description: '企业官网建设、域名注册与解析',
    },
    {
      title: '企业邮箱',
      description: '企业域名邮箱、基础反垃圾设置',
    },
    {
      title: '办公协作',
      description: '文档协作、即时通讯、任务管理',
    }
  ]

  return (
    <section className="py-20">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-12">核心服务</h2>
        <div className="grid md:grid-cols-3 gap-8">
          {services.map((service) => (
            <Card key={service.title} className="p-6">
              <div className="flex flex-col items-center text-center">
                <div className="w-16 h-16 bg-blue-100 rounded-full mb-4 flex items-center justify-center">
                  <div className="w-8 h-8 bg-blue-600 rounded-full"></div>
                </div>
                <h3 className="text-xl font-bold mb-2">{service.title}</h3>
                <p className="text-gray-600">{service.description}</p>
              </div>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
} 