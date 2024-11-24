export default function Features() {
  const features = [
    { title: '一对一专属服务', description: '专业团队贴心服务' },
    { title: '响应速度快', description: '快速响应客户需求' },
    { title: '方案灵活可调', description: '根据需求定制方案' },
    { title: '成本透明', description: '价格公开透明' }
  ]
  
  return (
    <section className="py-20">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-12">服务特色</h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature) => (
            <div key={feature.title} className="text-center">
              <h3 className="text-xl font-bold mb-2">{feature.title}</h3>
              <p className="text-gray-600">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
} 