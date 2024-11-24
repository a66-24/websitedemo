export default function Hero() {
  return (
    <section className="relative h-[600px] flex items-center bg-gradient-to-r from-blue-600 to-blue-700">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl text-white">
          <h1 className="text-4xl md:text-5xl font-bold mb-6 animate-fade-in">
            企业数字化服务解决方案
          </h1>
          <p className="text-xl mb-8 animate-fade-in" style={{animationDelay: '0.2s'}}>
            为企业提供专业的数字化转型服务，助力企业高效发展
          </p>
          <button className="bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold 
            hover:bg-blue-50 transition-colors animate-fade-in shadow-lg
            hover:shadow-xl transform hover:-translate-y-1 transition-all duration-200"
            style={{animationDelay: '0.4s'}}>
            立即咨询
          </button>
        </div>
      </div>
    </section>
  )
} 