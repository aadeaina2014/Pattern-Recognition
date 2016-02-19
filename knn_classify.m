%=========================================================================%
% Florida Insitute of Technology
% Coleege of Engineering
% Electrical and Computer Engineering Department
% ECE 5258   : Pattern Recognition
% Instructor : Dr. Georgios Anagnostopulous
% Semester   : Fall 2015
% Doc Ref    : K -Nearest Neigbor Classifier Script (knn_classify.m)
%  (c) Ayokunle Ade-Aina 
%=========================================================================%

%---------------------------------INPUT-----------------------------------%
%X              : query Samples  of dimension N x D
%Xref           : Training smamples of M * D 
% k             : Number of Nearest Neibors to  check
% p             : type of norm desired for distance measure
% unknown_Label : what to use for labelling when a tie occurs in KNN
% Ltrain        : Labels of reference samples Xref
%---------------------------------INPUT-----------------------------------%


%---------------------------------OUTPUT ---------------------------------%
%PCP   : N x D matrix containing posterior probability for each class
%YPred : Predicted Labels for each test pattern
%---------------------------------OUTPUT ---------------------------------%

function [Ypred, PCP]= knn_classify(X,Xref,k,p, unknown_label, Ltrain)

numClass = length(unique(Ltrain));

% check for k = 0 input
if k==0
    disp ('Invalid K , it is impossible to classify with zero nearest neigbors!')
   Ypred =0;
   PCP = 0;
else
    [a,~] = size(X);
    
    % check for k = 0 input
    if k==1 
        
        
        
        
        for i = 1: a
            % Measure distance between query points and training data
           
       % Compute matrix of difference between row vector of train samples 
       % and current traiining point
           v = size(Xref,1);
           M =  repmat(X(i, :),[v,1]);
           T =   Xref - M; 
           for n =  1:v;
           dist(n) = norm(T(n,:),p);
           end
         
            
            % k NN  takes place here
            [~,S2] =  sort (dist,2, 'ascend'); % find indices of k smallest distances
            idx = S2( 1);  % pick the smallest index 
            
            Ypred(i) =  Ltrain(idx,1);
            
            % Compute Posterior Probability using a voting algorithm
            uL =  unique(Ltrain);
            b = length(Ltrain)+1;
                  
            for  j = 1: length(uL)  % for each class
                zx  =find (Ltrain ==uL(j));
                count   = length( zx);
                if j==Ypred(i);
                    a = count + 1;
                    
                    pr(j)  = a/b;
                else
                    pr(j)  = count/b;
                end
                
            end
            PCP(i,:) = pr;
            
        end
        
        
    else
        
        
        for i = 1: a
            % Measure distance between query points and training data
            
          
           % dist = pdist2( X(i, :) , Xref);
            
             v = size(Xref,1);
          
           M =  repmat(X(i, :),[v,1]);
           T =   Xref - M;
           for n =  1:v;
           dist(n) = norm(T(n,:),p);
           end
            [~,S2] =  sort (dist,2, 'ascend');
            
            idx = S2( 1:k); % find indices of k smallest distances
            
            % Compute Vote Based on Probability
            Lpoll(i,:) =   Ltrain(idx,1)';
            %  Get Number of classes falling in Nearest neiborhood
            u = unique(Lpoll(i,:));
            
            % Compute label based on winner takes all
            for j = 1: length(u)
                a( j) = length(find ( Lpoll(i,:)== u(1,j))); % count number of labels for this class
            end
            
            uL =  unique(Ltrain);
            %------------------------vote for class label---------------------------%
       if length(a ) ==1       %  Check if only single labels are returned to query point
           Ypred(i) = u;
           zx  =find (Ltrain ==uL(j));
           count   = length( zx) + 1;
            b = length(Ltrain)+1;
            pr = count/b;
           PCP(i,:)  =  zeros(1,numClass);  % set all probabilities to zeroes since they do not have a count here
           PCP(i,u)  =  pr;    
       else
           
            if all(a == a(1))   % Check for a tie in voting Pattern
                
                Ypred(i) = unknown_label;
                for j=1:length(uL)
                    zx  =find (Ltrain ==uL(j));
                    count   = length( zx);
                    pr(j)  = count/length(Ltrain); %  return   prior probability for rejected test pattern
                end
                disp ('Tie detected, Label is unknown , Test Pattern Rejected!')
                PCP(i,:) = pr;
            else
                [ ~,  j] = max(a);
                Ypred(i) = j;
                nc  =   (a(j) + 1 )/(length(Ltrain) +1);
                
                % Compute Posterior Probability
                
                b = length(Ltrain)+1;
                
                
                for  j = 1: length(uL)  % for each class  compute the posterior probabilities
                    zx  =find (Ltrain ==uL(j));
                    count   = length( zx);
                    if j==Ypred(i);
                        a = count + 1;
                        
                        pr(j)  = a/b;
                    else
                        pr(j)  = count/b;
                    end
                    
                end
                PCP(i,:) = pr;
            end
       end
            %------------------------vote for class label---------------------------%
            
            
            
            
        end
        
    end
    
end
% function [Ypred, PCP]= knn_classify(X,Xref,k,p, unknown_label, Ltrain)
% 
% numClass = length(unique(Ltrain));
% 
% % check for k = 0 input
% if k==0
%     disp ('Invalid K , it is impossible to classify with zero nearest neigbors!')
%    Ypred =0;
%    PCP = 0;
% else
%     [a,~] = size(X);
%     
%     % check for k = 0 input
%     if k==1       
%         for i = 1: a   
%        % Compute matrix of difference between row vector of train samples 
%        % and current traiining point
%            v = size(Xref,1);
%            M =  repmat(X(i, :),[v,1]);
%            T =   Xref - M; 
%            for n =  1:v;
%            dist(n) = norm(T(n,:),p); % Measure distances between query point and training data samples
%            end
%          
%             
%             % k NN  takes place here
%             [~,S2] =  sort (dist,2, 'ascend'); % find indices of k smallest distances
%             idx = S2( 1);  % pick the smallest index 
%             Ypred(i) =  Ltrain(idx,1);
%             
%             % Compute Posterior Probability using a voting algorithm
%             uL =  unique(Ltrain);
%             b = length(Ltrain)+1;
%                   
%             for  j = 1: length(uL)  % for each class
%                 zx  =find (Ltrain ==uL(j));
%                 count   = length( zx);
%                 if j==Ypred(i);
%                     a = count + 1;
%                     pr(j)  = a/b;
%                 else
%                     pr(j)  = count/b;
%                 end
%             end
%             PCP(i,:) = pr; 
%         end    
%     else
%         
%         
%         for i = 1: a
%            v = size(Xref,1);
%            M =  repmat(X(i, :),[v,1]);
%            T =   Xref - M;
%            for n =  1:v;
%            dist(n) = norm(T(n,:),p);  %  Compute distance of query to each sample
%            end
%            
%            [~,S2] =  sort (dist,2, 'ascend');  % sort distance of query to each sample
%             
%             idx = S2( 1:k); % get index of nearest neigbhors  
%             Lpoll(i,:) =   Ltrain(idx,1)'; % Get Nearest  Neighbor Labels
%             u = unique(Lpoll(i,:));  % count number of unique nearest neighbors
%             
%             % Compute label based on winner takes all ( voting)
%             for j = 1: length(u)
%                 a( j) = length(find ( Lpoll(i,:)== u(1,j))); % count number of labels for this class
%             end
%             uL =  unique(Ltrain);
%             %------------------------vote for class label---------------------------%
%        if length(a ) ==1       %  Check if only single labels are returned to query point
%            Ypred(i) = u;
%            zx  =find (Ltrain ==uL(j));
%            count   = length( zx) + 1;
%             b = length(Ltrain)+1;
%             pr = count/b;
%            PCP(i,:)  =  zeros(1,numClass);  % set all probabilities to zeroes since they do not have a count here
%            PCP(i,u)  =  pr;    
%        else
%            
%             if all(a == a(1))   % Check for a tie in voting Pattern
%                 
%                 Ypred(i) = unknown_label;
%                 for j=1:length(uL)
%                     zx  =find (Ltrain ==uL(j));
%                     count   = length( zx);
%                     pr(j)  = count/length(Lpoll); %  return   prior probability for rejected test pattern
%                 end
%                 disp ('Tie detected, Label is unknown , Test Pattern Rejected!')
%                 PCP(i,:) = pr;
%             else
%                 [ ~,  j] = max(a);
%                 Ypred(i) = j;
%                 nc  =   (a(j) + 1 )/(length(Ltrain) +1);
%                 
%                 % Compute Posterior Probability
%                 
%                 b = length(Lpoll)+1;
%                 
%                 
%                 for  j = 1: length(uL)  % for each class  compute the posterior probabilities
%                     zx  =find (Ltrain ==uL(j));
%                     count   = length( zx);
%                     if j==Ypred(i);
%                         a = count + 1;
%                         
%                         pr(j)  = a/b; % compute posterior probability for winning label
%                     else
%                         pr(j)  = count/b; % compute  posterior probability for loosing labels
%                     end
%                     
%                 end
%                 PCP(i,:) = pr;
%             end
%        end
%             %------------------------vote for class label---------------------------%
%             
%             
%             
%             
%         end
%         
%     end
%     
% end