import random
import numpy as np
import scipy.special as sp 
import matplotlib.pyplot as plt

# k  -> 2/Co
# Co -> ultrasonic velocity

Co = 340 #meters/second
k = (2/Co)

# a  -> transducer radius (17 mm?)
a = 0.017 #meters

# T   -> 1/40 Khz = 25 us
T = 0.000025 #seconds

num_points = 1;

# Optimization Model Based Pseudo-Inverse (PINV)
#------------------------------------------------------------------------------------------

# Hi -> a matrix of pressues from each emitter for each desired pressure
# Po -> the median air density 
Po = 1.2 #kg/m^3

# w  -> 2*pi*f = 80000*pi
w = (80000 * np.pi)

# Initialize empty array to store each Hi
Hi_array = np.empty((256, num_points), dtype=complex)

for i in range(0, 16, 1):
    for j in range(0, 16, 1):
        for kpl in range(0, num_points):
            #TODO reshape the graph to fit the data points

            # input focal point coordinates
            x1 = 0.0
            y1 = 0.0

            #x2, y2, r, dx, dy, r, Di, and theta need to be calculated in the for loop
            #these need to be calculated
            x2 = ((7.5 - (15 - j)) / 1000) * 17
            y2 = ((-7.5 + (15 - i)) / 1000) * 17

            # height of the focal point
            z = 0.1

            # Calculate the differences in x and y
            dx = x2 - x1
            dy = y2 - y1
            dz = z - 0

            # Calculate the distance using NumPy
            r = np.sqrt(dx**2 + dy**2 + dz**2)
            
            # Di  -> phase = T - mod(r/Co, T)
            Di = (T) - (np.mod(((r / Co)), T))

            # value of theta
            theta = (np.arctan(z/(np.sqrt(dx**2 + dy**2))))

            # J_1(x) -> first-order Bessel function
            # sp.jv calculates the Bessel function of the first kind (same as sp.jn) and also handles complex values
            bessel = k*a*np.sin(theta)
            J_1 = sp.jv(1, bessel)

            equation_part_1 = (1j * ((Po * w * a**2) / (2 * r)))
            equation_part_2 = (((2 * J_1) * (k * a * np.sin(theta))) / (k * a * np.sin(theta)))
            equation_part_3 = (np.exp(1j * -k * r * 1000000))

            Hi = (equation_part_1 * equation_part_2 * equation_part_3)

            Hi_array[i*16 + j][0] = Hi

#------------------------------------------------------------------------------------------

#calculate matrix [16 x 16] u using H_conj_trans * [H * H_conj_trans] * P, follow order of ops

# H_conj_trans is the 256x16 conjugate transpose of H 
H_conj_trans = np.conj(Hi_array).T

# H is the 16x256 matrix
H = Hi_array

# Calculate H * H_conj_trans
HH_conj_trans = H * H_conj_trans

# P is the 16x16 desired pressure matrix
P = np.empty((num_points, 1))
P[0] = random.randint(0,15)

# Matrix multiplication
u_temp = (H_conj_trans * HH_conj_trans)

u = u_temp * P

angles_of_u = np.angle(u) * 180 / np.pi

for i in angles_of_u:
    print(i)

#------------------------------------------------------------------------------------------
# Split the complex matrix into real and imaginary parts

#use the real and imaginary parts of u here

real_part = np.real(Hi_array.conj().T)

imaginary_part = np.imag(Hi_array.conj().T)

# Create a single plot for both real and imaginary parts
plt.figure(figsize=(12, 6))

# Plot the real part in blue
plt.scatter(real_part, imaginary_part)

plt.title('Real and Imaginary Parts of Conjugate Transpose of Hi_array')
plt.xlabel('Real Part')
plt.ylabel('Fake Part')
plt.show()
