
import { Calendar, Clock, MessageSquare } from "lucide-react";
import { cn } from "@/lib/utils";

interface FeatureCardProps {
  title: string;
  description: string;
  icon: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
}

const FeatureCard = ({ title, description, icon, className, style }: FeatureCardProps) => {
  return (
    <div 
      className={cn(
        "bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-shadow hover-scale",
        className
      )}
      style={style}
    >
      <div className="h-12 w-12 flex items-center justify-center rounded-full bg-primary/10 text-primary mb-4">
        {icon}
      </div>
      <h3 className="text-xl font-semibold mb-2 text-gray-900">{title}</h3>
      <p className="text-gray-600">{description}</p>
    </div>
  );
};

const FeatureSection = () => {
  return (
    <section className="py-16 md:py-24 bg-gray-50">
      <div className="container mx-auto px-4 md:px-6">
        <div className="text-center max-w-2xl mx-auto mb-12">
          <h2 className="text-3xl md:text-4xl font-bold mb-4 text-gray-900">
            Everything You Need to Manage Your Coaching Business
          </h2>
          <p className="text-xl text-gray-600">
            Powerful tools designed to streamline your workflow and enhance client experience
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <FeatureCard 
            title="Easy Scheduling" 
            description="Allow clients to book sessions based on your availability, eliminating back-and-forth emails."
            icon={<Calendar className="h-6 w-6" />}
            className="animate-fade-in"
            />
          <FeatureCard 
            title="Session Management" 
            description="Organize all upcoming and past sessions in one place with detailed information and notes."
            icon={<Clock className="h-6 w-6" />}
            className="animate-fade-in"
            style={{ animationDelay: '0.2s' }}
            />
          <FeatureCard 
            title="Client Communication" 
            description="Built-in messaging system to keep all client communications in one secure location."
            icon={<MessageSquare className="h-6 w-6" />}
            className="animate-fade-in"
            style={{ animationDelay: '0.4s' }}
            />
        </div>
      </div>
    </section>
  );
};

export default FeatureSection;
