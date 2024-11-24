import { Card } from '@/components/ui/card'

const valueAddedServices = [
  {
    title: '企业工商服务',
    features: ['公司注册咨询', '基础资质办理', '银行开户协助']
  },
  {
    title: '数字化升级服务',
    features: ['电子印章对接', '支付系统接入', '小程序开发']
  }
]

export default function ValueAddedServices() {
  return (
    <section className="py-20 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-12">增值服务</h2>
        <div className="grid md:grid-cols-2 gap-8">
          {valueAddedServices.map((service) => (
            <Card key={service.title}>
              <h3 className="text-xl font-bold mb-4">{service.title}</h3>
              <ul className="space-y-2">
                {service.features.map((feature) => (
                  <li key={feature}>{feature}</li>
                ))}
              </ul>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
} 