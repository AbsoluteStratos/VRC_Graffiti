/*
MIT License

Copyright (c) 2023 Stratos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EditorDecalManager : MonoBehaviour
{
    public Material material;
    private Vector3 translation = new Vector3(0, 0, 0);
    private Vector3 scale = new Vector3(1, 1, 1);

	public void Start()
	{
        // Nothing
        Debug.Log(gameObject.name);
        Debug.Log(gameObject.transform.rotation);
	}

	public void Update(){
		// Set a Quaternion from the specified Euler angles.
        // Quaternion rotation = Quaternion.Euler(eulerAngles.x, eulerAngles.y, eulerAngles.z);
        Quaternion rotation =  Quaternion.Inverse(gameObject.transform.rotation);

        // Set the translation, rotation and scale parameters.
        Matrix4x4 m = Matrix4x4.TRS( translation, rotation,  scale);

        if (material != null){
            material.SetMatrix("rotationMatrix", m);
            material.SetVector("_scaleVector", gameObject.transform.localScale);
        }
	}
}
