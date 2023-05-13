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
