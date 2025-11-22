export default function Home() {
  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="text-center px-4">
        <h1 className="text-6xl md:text-8xl font-bold text-gray-900 mb-4">
          Coming Soon
        </h1>
        <p className="text-xl md:text-2xl text-gray-600 mb-8">
          We're working on something amazing. Stay tuned!
        </p>
        <div className="inline-block animate-pulse">
          <div className="h-2 w-32 bg-indigo-600 rounded"></div>
        </div>
      </div>
    </main>
  )
}

