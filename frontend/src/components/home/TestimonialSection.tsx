
import { useState } from "react";
import { cn } from "@/lib/utils";

interface Testimonial {
  id: number;
  quote: string;
  author: string;
  role: string;
  image: string;
}

const testimonials: Testimonial[] = [
  {
    id: 1,
    quote: "CoachFlow has transformed how I manage my coaching practice. I've increased client retention by 40% since I started using the platform.",
    author: "Sarah Johnson",
    role: "Life Coach",
    image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80"
  },
  {
    id: 2,
    quote: "As a client, booking sessions with my coach used to be a hassle. With CoachFlow, I can see availability instantly and schedule in seconds.",
    author: "Michael Chen",
    role: "Business Professional",
    image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80"
  },
  {
    id: 3,
    quote: "The dashboard gives me a complete overview of all my clients and sessions. It's intuitive and has cut my admin time in half.",
    author: "Jessica Williams",
    role: "Career Coach",
    image: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80"
  }
];

const TestimonialSection = () => {
  const [activeIndex, setActiveIndex] = useState(0);
  
  return (
    <section className="py-16 md:py-24">
      <div className="container mx-auto px-4 md:px-6">
        <div className="text-center max-w-2xl mx-auto mb-12">
          <h2 className="text-3xl md:text-4xl font-bold mb-4 text-gray-900">
            Trusted by Coaches and Clients
          </h2>
          <p className="text-xl text-gray-600">
            Hear what our users have to say about their experience
          </p>
        </div>
        
        <div className="max-w-4xl mx-auto">
          <div className="relative bg-white rounded-2xl shadow-lg p-8 md:p-12">
            <div className="absolute top-0 left-0 transform -translate-y-1/2 -translate-x-4">
              <svg width="64" height="64" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M32 0C14.327 0 0 14.327 0 32C0 49.673 14.327 64 32 64C49.673 64 64 49.673 64 32C64 14.327 49.673 0 32 0ZM20.8 44.8C18.48 44.8 16.8 43.12 16.8 40.8C16.8 38.48 18.48 36.8 20.8 36.8C23.12 36.8 24.8 38.48 24.8 40.8C24.8 43.12 23.12 44.8 20.8 44.8ZM22.88 33.44L20.16 24C27.12 22.56 32 26.88 32 33.44H22.88ZM43.2 44.8C40.88 44.8 39.2 43.12 39.2 40.8C39.2 38.48 40.88 36.8 43.2 36.8C45.52 36.8 47.2 38.48 47.2 40.8C47.2 43.12 45.52 44.8 43.2 44.8ZM45.28 33.44L42.56 24C49.52 22.56 54.4 26.88 54.4 33.44H45.28Z" fill="#E5E7EB" />
              </svg>
            </div>
            
            {testimonials.map((testimonial, idx) => (
              <div 
                key={testimonial.id} 
                className={cn(
                  "transition-opacity duration-500",
                  idx === activeIndex ? "opacity-100" : "opacity-0 absolute inset-0"
                )}
              >
                <blockquote className="mb-8">
                  <p className="text-xl md:text-2xl text-gray-800 italic">"{testimonial.quote}"</p>
                </blockquote>
                
                <div className="flex items-center">
                  <img 
                    src={testimonial.image} 
                    alt={testimonial.author} 
                    className="w-12 h-12 rounded-full object-cover" 
                  />
                  <div className="ml-4">
                    <p className="font-medium text-gray-900">{testimonial.author}</p>
                    <p className="text-gray-600">{testimonial.role}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
          
          <div className="flex justify-center mt-8 space-x-2">
            {testimonials.map((_, idx) => (
              <button
                key={idx}
                className={cn(
                  "w-2.5 h-2.5 rounded-full transition-colors",
                  idx === activeIndex ? "bg-primary" : "bg-gray-300"
                )}
                onClick={() => setActiveIndex(idx)}
                aria-label={`View testimonial ${idx + 1}`}
              />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default TestimonialSection;
