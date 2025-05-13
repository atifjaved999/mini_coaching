import { useState } from "react";
import DashboardLayout from "@/components/dashboard/DashboardLayout";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Calendar as CalendarIcon, Edit, Plus, Trash } from "lucide-react";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { format } from "date-fns";
import { cn } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";

// Form schema for session creation/editing
const sessionSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string(),
  date: z.date(),
  startTime: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/, "Must be in format HH:MM"),
  endTime: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/, "Must be in format HH:MM"),
  clientName: z.string().min(2, "Client name is required"),
});

type SessionFormValues = z.infer<typeof sessionSchema>;

// Mock session data
interface Session {
  id: string;
  title: string;
  description: string;
  date: Date;
  startTime: string;
  endTime: string;
  clientName: string;
  status: "upcoming" | "completed" | "cancelled";
}

const initialSessions: Session[] = [
  {
    id: "1",
    title: "Career Development Planning",
    description: "Setting 3-month goals and creating action plan.",
    date: new Date(2025, 4, 15),
    startTime: "10:00",
    endTime: "11:00",
    clientName: "Alice Smith",
    status: "upcoming",
  },
  {
    id: "2",
    title: "Leadership Skills Assessment",
    description: "Review of leadership assessment results and planning next steps.",
    date: new Date(2025, 4, 16),
    startTime: "14:00",
    endTime: "15:30",
    clientName: "Bob Johnson",
    status: "upcoming",
  },
  {
    id: "3",
    title: "Communication Workshop",
    description: "Focus on improving team communication strategies.",
    date: new Date(2025, 4, 10),
    startTime: "11:00",
    endTime: "12:00",
    clientName: "Carol Williams",
    status: "completed",
  },
];

const SessionManagement = () => {
  const [sessions, setSessions] = useState<Session[]>(initialSessions);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedSession, setSelectedSession] = useState<Session | null>(null);
  const { toast } = useToast();
  
  const form = useForm<SessionFormValues>({
    resolver: zodResolver(sessionSchema),
    defaultValues: {
      title: "",
      description: "",
      date: new Date(),
      startTime: "09:00",
      endTime: "10:00",
      clientName: "",
    },
  });

  const handleOpenDialog = (session: Session | null = null) => {
    setSelectedSession(session);
    
    if (session) {
      form.reset({
        title: session.title,
        description: session.description,
        date: session.date,
        startTime: session.startTime,
        endTime: session.endTime,
        clientName: session.clientName,
      });
    } else {
      form.reset({
        title: "",
        description: "",
        date: new Date(),
        startTime: "09:00",
        endTime: "10:00",
        clientName: "",
      });
    }
    
    setIsDialogOpen(true);
  };

  const handleSubmit = (values: SessionFormValues) => {
    if (selectedSession) {
      // Update existing session
      setSessions(sessions.map(session => 
        session.id === selectedSession.id 
          ? { ...session, ...values } 
          : session
      ));
      toast({
        title: "Session updated",
        description: "Your coaching session has been updated successfully.",
      });
    } else {
      // Create new session
      const newSession: Session = {
        id: Math.random().toString(36).substring(2, 9),
        title: values.title,
        description: values.description,
        date: values.date,
        startTime: values.startTime,
        endTime: values.endTime,
        clientName: values.clientName,
        status: "upcoming",
      };
      setSessions([...sessions, newSession]);
      toast({
        title: "Session created",
        description: "Your new coaching session has been scheduled.",
      });
    }
    
    setIsDialogOpen(false);
  };

  const handleDelete = (id: string) => {
    setSessions(sessions.filter(session => session.id !== id));
    toast({
      title: "Session deleted",
      description: "The session has been removed from your calendar.",
      variant: "destructive",
    });
  };
  
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900">Session Management</h1>
          <Button onClick={() => handleOpenDialog()}>
            <Plus className="h-4 w-4 mr-2" />
            New Session
          </Button>
        </div>
        
        <div className="grid grid-cols-1 gap-4">
          <SessionList 
            sessions={sessions} 
            onEdit={handleOpenDialog}
            onDelete={handleDelete}
          />
        </div>
      </div>
      
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="sm:max-w-[525px]">
          <DialogHeader>
            <DialogTitle>
              {selectedSession ? "Edit Session" : "Create New Session"}
            </DialogTitle>
            <DialogDescription>
              {selectedSession 
                ? "Update the details of your coaching session." 
                : "Fill in the details to schedule a new coaching session."}
            </DialogDescription>
          </DialogHeader>
          
          <Form {...form}>
            <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
              <FormField
                control={form.control}
                name="title"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Session Title</FormLabel>
                    <FormControl>
                      <Input placeholder="Career Coaching Session" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Description</FormLabel>
                    <FormControl>
                      <Textarea 
                        placeholder="Brief description of the session..." 
                        className="resize-none"
                        {...field} 
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="date"
                  render={({ field }) => (
                    <FormItem className="flex flex-col">
                      <FormLabel>Date</FormLabel>
                      <Popover>
                        <PopoverTrigger asChild>
                          <FormControl>
                            <Button
                              variant={"outline"}
                              className={cn(
                                "w-full pl-3 text-left font-normal",
                                !field.value && "text-muted-foreground"
                              )}
                            >
                              {field.value ? (
                                format(field.value, "PPP")
                              ) : (
                                <span>Pick a date</span>
                              )}
                              <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                            </Button>
                          </FormControl>
                        </PopoverTrigger>
                        <PopoverContent className="w-auto p-0" align="start">
                          <Calendar
                            mode="single"
                            selected={field.value}
                            onSelect={field.onChange}
                            disabled={(date) =>
                              date < new Date(new Date().setHours(0, 0, 0, 0))
                            }
                            initialFocus
                          />
                        </PopoverContent>
                      </Popover>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                
                <FormField
                  control={form.control}
                  name="clientName"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Client Name</FormLabel>
                      <FormControl>
                        <Input placeholder="John Doe" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="startTime"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Start Time</FormLabel>
                      <FormControl>
                        <Input type="time" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                
                <FormField
                  control={form.control}
                  name="endTime"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>End Time</FormLabel>
                      <FormControl>
                        <Input type="time" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
              
              <DialogFooter>
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                  Cancel
                </Button>
                <Button type="submit">
                  {selectedSession ? "Update Session" : "Create Session"}
                </Button>
              </DialogFooter>
            </form>
          </Form>
        </DialogContent>
      </Dialog>
    </DashboardLayout>
  );
};

interface SessionListProps {
  sessions: Session[];
  onEdit: (session: Session) => void;
  onDelete: (id: string) => void;
}

const SessionList = ({ sessions, onEdit, onDelete }: SessionListProps) => {
  // Filter and sort sessions: upcoming first, then completed
  const sortedSessions = [...sessions].sort((a, b) => {
    // First by status
    if (a.status === "upcoming" && b.status !== "upcoming") return -1;
    if (a.status !== "upcoming" && b.status === "upcoming") return 1;
    
    // Then by date
    return a.date.getTime() - b.date.getTime();
  });
  
  return (
    <div className="bg-white rounded-lg shadow overflow-hidden">
      <div className="p-4 bg-gray-50 border-b">
        <h3 className="font-medium">Your Coaching Sessions</h3>
      </div>
      
      {sortedSessions.length === 0 ? (
        <div className="p-8 text-center text-gray-500">
          <p>No sessions scheduled. Create a new session to get started.</p>
        </div>
      ) : (
        <ul>
          {sortedSessions.map((session) => (
            <li key={session.id} className="border-b last:border-b-0">
              <div className="p-4 hover:bg-gray-50 transition-colors flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className={cn(
                    "w-3 h-3 rounded-full",
                    session.status === "upcoming" ? "bg-green-500" : 
                    session.status === "completed" ? "bg-gray-400" : "bg-red-500"
                  )} />
                  <div>
                    <h4 className="font-medium">{session.title}</h4>
                    <p className="text-sm text-gray-600">
                      {format(session.date, "MMM dd, yyyy")} • {session.startTime} - {session.endTime}
                    </p>
                    <p className="text-sm text-gray-500">Client: {session.clientName}</p>
                  </div>
                </div>
                
                <div className="flex space-x-2">
                  <Button 
                    size="icon" 
                    variant="ghost" 
                    onClick={() => onEdit(session)}
                    className="h-8 w-8"
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button 
                    size="icon" 
                    variant="ghost" 
                    onClick={() => onDelete(session.id)}
                    className="h-8 w-8 text-red-500 hover:text-red-600 hover:bg-red-50"
                  >
                    <Trash className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default SessionManagement;
