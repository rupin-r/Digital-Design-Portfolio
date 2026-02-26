using UnityEngine;

using System;
using System.Net;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Numerics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MathNet.Numerics;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Complex;


public class RelativeCubePositions : MonoBehaviour
{
    //reference to the esp script
    public Esp32Socket Socket;
    //reference to all the 256 sphere of the board
    public Transform[] Spheres;
    public static UnityEngine.Vector3[] relativePositions;
    //reference to all the sphere in your hand going from the fingertip to the palm of your hand
    public Transform Index_4;
    public Transform Index_3;
    public Transform Index_2;
    public Transform Index_1;
    public Transform Index_1_1;
    public Transform Index_1_2;
    public Transform Index_1_3;
    public Transform Index_1_4;
    public Transform Index_1_5;
    public Transform Index_1_6;

    //made variables placeholder for index sphere to convert from transform to gameobject
    GameObject Index_4_GameObject;
    GameObject Index_3_GameObject;
    GameObject Index_2_GameObject;
    GameObject Index_1_GameObject;
    GameObject Index_1_1_GameObject;
    GameObject Index_1_2_GameObject;
    GameObject Index_1_3_GameObject;
    GameObject Index_1_4_GameObject;
    GameObject Index_1_5_GameObject;
    GameObject Index_1_6_GameObject;

    //variables for rgb intensity
    public float redIntensity = 1.0f;
    public float greenIntensity = 1.0f;
    public float blueIntensity = 1.0f;
    float timer;
    private float updateTimer = 0f;
    private float updateInterval = 2f; // Update every 2 seconds, so in the update function it run the function every 2 seconds

    //counter for the sphere in the hand going from your fingertip to the palm of your hand 
    int indexfingercounter = 0;
    //everything that is inside the start function only run once when the script is run
    void Start()
    {
        timer = 0f;
        relativePositions = new UnityEngine.Vector3[10];
        //get the transformation of all the sphere in the hand
        Index_4 = GameObject.Find("Index_4").transform;
        Index_3 = GameObject.Find("Index_3").transform;
        Index_2 = GameObject.Find("Index_2").transform;
        Index_1 = GameObject.Find("Index_1").transform;
        Index_1_1 = GameObject.Find("Index_1_1").transform;
        Index_1_2 = GameObject.Find("Index_1_2").transform;
        Index_1_3 = GameObject.Find("Index_1_3").transform;
        Index_1_4 = GameObject.Find("Index_1_4").transform;
        Index_1_5 = GameObject.Find("Index_1_5").transform;
        Index_1_6 = GameObject.Find("Index_1_6").transform;

        //connecting to the wifi
        Socket = new Esp32Socket();
        Socket.Connect("192.168.4.1", 50000);

    }

    //everything that is inside the update function run every 2 seconds
    void Update()
    {
        //get the position of the cube from the oculus quest 2 camera
        UnityEngine.Vector3 mainposition = transform.position;
        //get all the relative position from the sphere in the hand to the cube
        relativePositions[0] = Index_4.position - mainposition;
        relativePositions[1] = Index_3.position - mainposition;
        relativePositions[2] = Index_2.position - mainposition;
        relativePositions[3] = Index_1.position - mainposition;
        relativePositions[4] = Index_1_1.position - mainposition;
        relativePositions[5] = Index_1_2.position - mainposition;
        relativePositions[6] = Index_1_3.position - mainposition;
        relativePositions[7] = Index_1_4.position - mainposition;
        relativePositions[8] = Index_1_5.position - mainposition;
        relativePositions[9] = Index_1_6.position - mainposition;

        updateTimer += Time.deltaTime;

        //timer update
        if (updateTimer >= updateInterval)
        {

            updateTimer = 0f;

            //this section print all the x,y,z position of all the spheres in the hand from fingertip to palm
            string position0 = "Index_4: " + relativePositions[0].x + ", " + relativePositions[0].y + ", " + relativePositions[0].z + "\n";
            Debug.Log(position0);
            double xValue0 = relativePositions[0].x;
            double yValue0 = relativePositions[0].y;
            double zValue0 = relativePositions[0].z;

            string position1 = "Index_3:" + relativePositions[1].x + ", " + relativePositions[1].y + ", " + relativePositions[1].z + "\n";

            Debug.Log(position1);
            double xValue1 = relativePositions[1].x;
            double yValue1 = relativePositions[1].y;
            double zValue1 = relativePositions[1].z;

            string position2 = "Index_2:" + relativePositions[2].x + ", " + relativePositions[2].y + ", " + relativePositions[2].z + "\n";
            Debug.Log(position2);
            double xValue2 = relativePositions[2].x;
            double yValue2 = relativePositions[2].y;
            double zValue2 = relativePositions[2].z;

            string position3 = "Index_1:" + relativePositions[3].x + ", " + relativePositions[3].y + ", " + relativePositions[3].z + "\n";
            Debug.Log(position3);
            double xValue3 = relativePositions[3].x;
            double yValue3 = relativePositions[3].y;
            double zValue3 = relativePositions[3].z;

            string position4 = "Index_1_1:" + relativePositions[4].x + ", " + relativePositions[4].y + ", " + relativePositions[4].z + "\n";
            Debug.Log(position4);
            double xValue4 = relativePositions[4].x;
            double yValue4 = relativePositions[4].y;
            double zValue4 = relativePositions[4].z;

            string position5 = "Index_1_2:" + relativePositions[5].x + ", " + relativePositions[5].y + ", " + relativePositions[5].z + "\n";
            Debug.Log(position5);
            double xValue5 = relativePositions[5].x;
            double yValue5 = relativePositions[5].y;
            double zValue5 = relativePositions[5].z;

            string position6 = "Index_1_3:" + relativePositions[6].x + ", " + relativePositions[6].y + ", " + relativePositions[6].z + "\n";
            Debug.Log(position6);
            double xValue6 = relativePositions[6].x;
            double yValue6 = relativePositions[6].y;
            double zValue6 = relativePositions[6].z;

            string position7 = "Index_1_4:" + relativePositions[7].x + ", " + relativePositions[7].y + ", " + relativePositions[7].z + "\n";
            Debug.Log(position7);
            double xValue7 = relativePositions[7].x;
            double yValue7 = relativePositions[7].y;
            double zValue7 = relativePositions[7].z;

            string position8 = "Index_1_5:" + relativePositions[8].x + ", " + relativePositions[8].y + ", " + relativePositions[8].z + "\n";
            Debug.Log(position8);
            double xValue8 = relativePositions[8].x;
            double yValue8 = relativePositions[8].y;
            double zValue8 = relativePositions[8].z;

            string position9 = "Index_1_6:" + relativePositions[9].x + ", " + relativePositions[9].y + ", " + relativePositions[9].z + "\n";
            Debug.Log(position9);
            double xValue9 = relativePositions[9].x;
            double yValue9 = relativePositions[9].y;
            double zValue9 = relativePositions[9].z;

            //create a array of gameobject
            GameObject[] GameObjectsArray = new GameObject[10];

            //convert transform to gameobject
            GameObjectsArray[0] = Index_4.gameObject;
            GameObjectsArray[1] = Index_3.gameObject;
            GameObjectsArray[2] = Index_2.gameObject;
            GameObjectsArray[3] = Index_1.gameObject;
            GameObjectsArray[4] = Index_1_1.gameObject;
            GameObjectsArray[5] = Index_1_2.gameObject;
            GameObjectsArray[6] = Index_1_3.gameObject;
            GameObjectsArray[7] = Index_1_4.gameObject;
            GameObjectsArray[8] = Index_1_5.gameObject;
            GameObjectsArray[9] = Index_1_6.gameObject;


            //set all of the sphere invisible
            for (int i = 0; i < 10; i++)
            {
                GameObjectsArray[i].SetActive(false);
            }

            //set one of the sphere visible 
            GameObjectsArray[indexfingercounter].SetActive(true);

            //reset it going back to palm to fingertip
            if (indexfingercounter == 9)
            {
                indexfingercounter = 0;
            }

            //if not, then spheres keep going from fingertip to palm 
            if (indexfingercounter < 9)
            {
                indexfingercounter++;
            }

            // Constants
            double w = 2 * Math.PI * 40000.0; // Hz transmitter frequency
            double c0 = 340.0; // m/s speed of sound
            double k = w / c0; // wave number
            double a = 0.008; // m transmitter radius
            double p0 = 1.2; // kg/m^3 median air density
            double T = 25; // us period

            // Input
            int numFocalPoints = 1;
            double[,] focal = new double[numFocalPoints, 4];

             // Assign values to the focal array
            focal[0, 0] = relativePositions[indexfingercounter].x;
            focal[0, 1] = relativePositions[indexfingercounter].z;
            focal[0, 2] = relativePositions[indexfingercounter].y;
            focal[0, 3] = 100;
            /*focal[1, 0] = relativePositions[3].x;
            focal[1, 1] = relativePositions[3].z;
            focal[1, 2] = relativePositions[3].y;
            focal[1, 3] = 100;
            focal[2, 0] = relativePositions[2].x;
            focal[2, 1] = relativePositions[2].z;
            focal[2, 2] = relativePositions[2].y;
            focal[2, 3] = 100;
            focal[3, 0] = relativePositions[3].x;
            focal[3, 1] = relativePositions[3].z;
            focal[3, 2] = relativePositions[3].y;
            focal[3, 3] = 100;
            focal[4, 0] = relativePositions[4].x;
            focal[4, 1] = relativePositions[4].z;
            focal[4, 2] = relativePositions[4].y;
            focal[4, 3] = 100;
            */

                        // Create a 2D complex number array H
            Complex[,] H = new Complex[numFocalPoints, 256];

            // Create a 2D array P
            int[,] P = new int[1, numFocalPoints];
            for(int i = 0; i < numFocalPoints; i++)
            {
                P[0, i] = 100;
            }

            // Populate H array
            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    for (int m = 0; m < numFocalPoints; m++)
                    {
                        // Calculate coordinates
                        double x_i = ((7.5 - (15 - j)) / 1000) * 16;
                        double y_i = ((-7.5 + (15 - i)) / 1000) * 16;

                        // Calculate distance
                        double dx = focal[m, 0] - x_i;
                        double dy = focal[m, 1] - y_i;
                        double dz = focal[m, 2];

                        // Calculate distance r
                        double r = Math.Sqrt(dx * dx + dy * dy + dz * dz);

                        // Calculate time delay delta_T
                        double delta_T = r / c0;

                        // Calculate time offset D_i
                        double D_i = (T - (Math.Round(delta_T * 1000000) % T)) / 1000000;

                        // Calculate theta angle
                        double theta = Math.Atan(dz / (Math.Sqrt(dx * dx + dy * dy)));

                        // Calculate bessel function
                        double bessel = k * a * Math.Sin(theta);
                        double J_1 = SpecialFunctions.BesselJ(1, bessel);

                        // Calculate H formula components
                        Complex part1 = new Complex(0, 1) * p0 * w * a * a / r;
                        Complex part2 = J_1 / (k * a * Math.Sin(theta));
                        Complex part3 = Complex.Exp(new Complex(0, 1) * k * r * (-1));

                        // Calculate final H value for i,j,m
                        H[m, i * 16 + j] = part1 * part2 * part3;

                    }
                }
            }


            //After populating the H matrix using the code you provided
            //for (int i = 0; i < 256; i++)
            //{
            //    for (int j = 0; j < 4; j++)
            //    {
            //        Console.Write(H[j, i] + "   \t");
            //    }
            //    Console.WriteLine(); // Move to the next row
            //}

            // H_cong_trans = Complex.Conjugate(H).Transpose();

            /*
            U = H * (H * HT)^-1 * P
            H_conj_trans = HT
            H_mix = H * HT
            H_final = PseudoInverse of H_mix
            initial_u = H * H_final
            final_u = initial_u * P
            */

            // Transpose conjugate of H
            Complex[,] H_conj_trans = new Complex[256, numFocalPoints];

            // Transpose conjugate of H
            for (int i = 0; i < 256; i++)
            {
                for (int j = 0; j < numFocalPoints; j++)
                {
                    H_conj_trans[i, j] = Complex.Conjugate(H[j, i]);
                }
            }

            // H_mix = new Complex[numFocalPoints, numFocalPoints];
            
            // Calculate H_mix matrix
            Complex[,] H_mix = new Complex[numFocalPoints, numFocalPoints];

            for (int i = 0; i < numFocalPoints; i++)
            {
                for (int j = 0; j < numFocalPoints; j++)
                {
                    // Calculate H_mix values
                    Complex sum = 0;
                    for (int m = 0; m < 256; m++)
                    {
                        sum += H[i, m] * H_conj_trans[m, j];
                    }
                    H_mix[i, j] = sum;
                }
            }

            var matrix = Matrix<Complex>.Build.DenseOfArray(H_mix);

            // Calculate pseudo inverse of H_mix
            var svd = matrix.Svd(true);

            var U = svd.U;
            var S = svd.S;
            var VT = svd.VT;

            // Compute the pseudoinverse
            var pseudoinverse = ComputePseudoInverse(U, S, VT);
            int rows = pseudoinverse.RowCount;
            int cols = pseudoinverse.ColumnCount;
            //Console.WriteLine($"Pseudoinverse Matrix Dimensions: {rows}x{cols}");

            // Calculate final_u
            Complex[,] H_final = new Complex[numFocalPoints, 256];

            for (int i = 0; i < 256; i++)
            {
                for (int j = 0; j < numFocalPoints; j++)
                {
                    Complex sum = 0;

                    for (int l = 0; l < numFocalPoints; l++)
                    {
                        Complex product = H[l, i] * pseudoinverse[j, l];

                        if (double.IsNaN(H[l, i].Real) || double.IsNaN(H[l, i].Imaginary) || double.IsNaN(pseudoinverse[l, j].Real) || double.IsNaN(pseudoinverse[l, j].Imaginary))
                        {
                            product = Complex.Zero;
                            Console.WriteLine($"NaN detected at l={l}, i={i}, j={j}: H[l, i]={H[l, i]}, pseudoinverse[l, j]={pseudoinverse[l, j]}");
                        }

                        sum += product;
                    }

                    // Check for NaN or Infinity values in the final sum
                    if (double.IsNaN(sum.Real) || double.IsNaN(sum.Imaginary) || double.IsInfinity(sum.Real) || double.IsInfinity(sum.Imaginary))
                    {
                        sum = Complex.Zero;
                    }

                    H_final[j, i] = sum;
                }
            }
                Complex[,] final_u = new Complex[1, 256];

            for (int i = 0; i < 256; i++)
            {
                Complex sum = 0;
                for (int j = 0; j < numFocalPoints; j++)
                {
                    sum += H_final[j, i] * P[0, j];
                }
                final_u[0, i] = sum;
                //Console.WriteLine(final_u[0, i]);
            }

            // Print angles
            int [,] angles = new int[16,16];

            // Calculate angles
            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    // Calculate angle from phase
                    double unrounded = (final_u[0, i * 16 + j].Phase * 180 / Math.PI);
                    double rounded = Math.Round(unrounded);

                    int angle = (int)rounded;
                    
                    // Handle negative angles
                    if (angle < 0)
                    {
                        angle += 360;
                    }

                    // Calculate scaled angle
                    int angleMod = angle % 360;
                    int scaled = (int)(angleMod / 4.5);

                    angles[i,j] = scaled;

                    //Spheres[i*16 + j].transform.position = new UnityEngine.Vector3(mainposition.x + (float)(1.7*((7.5 - (15 - j))/100)), mainposition.y + ((float)(scaled) / (float)(1000)), mainposition.z + (float)(1.7*((-7.5 + (15 - i))/100)));

                    Console.Write(scaled + "\t");
                }
                //Console.WriteLine();
            }

            // Calculate pressures
            Double[,] pressures = new Double[16, 16];

            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    // Calculate pressure sum
                    Double sum_pressure = 0;
                    for (int m = 0; m < 16; m++)
                    {
                        for (int n = 0; n < 16; n++)
                        {
                            // Calculate coordinates
                            double x = ((7.5 - (15 - j)) / 1000) * 16;
                            double y = ((-7.5 + (15 - i)) / 1000) * 16;

                            double x_i = ((7.5 - (15 - n)) / 1000) * 16;
                            double y_i = ((-7.5 + (15 - m)) / 1000) * 16;

                            // Calculate distance
                            double dx = x - x_i;
                            double dy = y - y_i;
                            double dz = focal[0, 2];

                            // Calculate pressure contribution
                            double r = Math.Sqrt(dx * dx + dy * dy + dz * dz) * 10000;
                            double outofphase = r % 86;
                            outofphase = (outofphase * 80) / 86;
                        
                            double phase_out = (outofphase + angles[m,n]) % 80;
                            double part_pressure = (double)(phase_out) / (double)(r);

                            if (phase_out >= 40)
                            {
                                sum_pressure -= part_pressure * Math.Abs((Math.Abs(phase_out - 60.0) - 20.0)) / 20.0;
                            }
                            else
                            {
                                sum_pressure += part_pressure * Math.Abs((Math.Abs(phase_out - 60.0) - 20.0)) / 20.0;
                            }
                            //Console.WriteLine(sum_pressure);
                        }
                    }
                    // Accumulate pressure sum
                    pressures[i, j] = sum_pressure + 1;
                    //Console.Write(Math.Round(pressures[i, j], 2) + "\t");
                }
                //Console.WriteLine();
            }

            // Apply pressures to spheres    
            for (int i3 = 0; i3 < 16; i3++)
            {
                for (int j3 = 0; j3 < 16; j3++)
                {   
                    // Get pressure value
                    float pressure = (float)pressures[i3, j3];
                    float redIntensity = Mathf.Clamp01(pressure / 2.0f); // Adjust the factor as needed
                    float greenIntensity = 0.0f; // No green component
                    float blueIntensity = 0.0f; // No blue component

                    // Update sphere position, scale and color
                    Spheres[i3*16 + j3].transform.position = new UnityEngine.Vector3(mainposition.x + (float)(1.7 * ((7.5 - (15 - j3))/100)), mainposition.y + (float)((pressures[i3,j3]) * 0.05), mainposition.z + (float)(1.7 * ((-7.5 + (15 - i3))/100)));
                    Spheres[i3*16 + j3].transform.localScale = new UnityEngine.Vector3((float)(0.01), (float)((pressures[i3,j3]) * 0.1), (float)(0.01));

                    Renderer sphereRenderer = Spheres[i3 * 16 + j3].GetComponent<Renderer>();

                    // Create a new color with adjusted red intensity, keeping the original green and blue components
                    Color adjustedColor = new Color(redIntensity, greenIntensity, blueIntensity);
                    sphereRenderer.material.color = adjustedColor; // Set the adjusted color
                }

            }
                


            static Matrix<Complex> ComputePseudoInverse(Matrix<Complex> U, MathNet.Numerics.LinearAlgebra.Vector<Complex> S, Matrix<Complex> VT)
            {
                // Compute the pseudoinverse of S
                var pseudoinverseS = MathNet.Numerics.LinearAlgebra.Vector<Complex>.Build.DenseOfEnumerable(
                    S.Select(singularValue => Complex.Abs(singularValue) < 1e-15 ? Complex.Zero : Complex.Reciprocal(singularValue))
                );

                // Create the diagonal pseudoinverse S matrix
                var pseudoinverseSMatrix = Matrix<Complex>.Build.DiagonalOfDiagonalArray(pseudoinverseS.ToArray());

                // Compute the pseudoinverse of the original matrix
                var pseudoinverse = VT.ConjugateTranspose() * pseudoinverseSMatrix * U.ConjugateTranspose();

                return pseudoinverse;
            }
    }
}
    // Calculate angles array
    double[] ConstructAnglesArray(Complex[,] big_U)
    {
        // Code to extract angles into array
        double[] anglesArray = new double[16 * 16];
        int index = 0;

        for (int i = 0; i < 16; i++)
        {
            for (int j = 0; j < 16; j++)
            {
                double unrounded = (big_U[0, i * 16 + j].Phase * 180 / Math.PI);
                double rounded = Math.Round(unrounded);
                int angle = (int)rounded;

                if (angle < 0)
                {
                    angle += 360;
                }

                anglesArray[index] = angle;
                index++;
            }
        }
        return anglesArray;
    }

    // Cleanup on destroy
    void OnDestroy()
    {
        Debug.Log("Alsta la vista fuckers");
        // Socket.Close();
    }
}
