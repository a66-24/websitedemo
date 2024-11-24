export default function Cooperation() {
  const policies = [
    { title: '老带新奖励', description: '成交额10%' },
    { title: '长期合作优惠', description: '年付88折' },
    { title: '打包服务优惠', description: '满3项9折' }
  ]

  return (
    <section className="py-20 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-12">合作政策</h2>
        <div className="grid md:grid-cols-3 gap-8">
          {policies.map((policy) => (
            <div key={policy.title} className="text-center">
              <h3 className="text-xl font-bold mb-2">{policy.title}</h3>
              <p className="text-gray-600">{policy.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
} 